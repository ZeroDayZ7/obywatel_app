import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:obywatel_plus/core/crypto/crypto_service.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/backend_sync.dart';
import 'package:obywatel_plus/core/security/local_auth_provider.dart';
import 'package:obywatel_plus/core/security/pin/pin_attempt_limiter.dart';
import 'package:obywatel_plus/core/security/pin/pin_attempt_state.dart';
import 'package:obywatel_plus/core/security/pin/pin_service.dart';
import 'package:obywatel_plus/core/security/pin/pin_verification_state.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_state.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pin_verification_notifier.g.dart';

@Riverpod(keepAlive: true)
class PinVerificationNotifier extends _$PinVerificationNotifier {
  /// Flaga ręcznego włączania/wyłączania szczegółowych logów debugowych w tym pliku.
  // static const bool _enableVerboseLogging = false;

  Timer? _lockoutTimer;
  bool _hasAttemptedAutoBiometrics = false;
  bool _isBiometricPromptInProgress = false;

  AppLogger get _log => ref.read(appLoggerProvider);

  // void _logDebug(String message) {
  //   if (_enableVerboseLogging) {
  //     _log.d(message);
  //   }
  // }

  @override
  PinVerificationState build() {
    ref.listen<AsyncValue<PinAttemptState>>(pinAttemptLimiterProvider, (
      prev,
      next,
    ) {
      next.whenData((data) {
        if (data.isLocked && _lockoutTimer == null) {
          _startLockoutTimer(data.lockUntil!);
        }
      });
    });

    ref.onDispose(() => _lockoutTimer?.cancel());
    return const PinVerificationState.idle();
  }

  /// Wyzwalanie autoryzacji biometrycznej przeniesione do Notifiera.
  /// Biometria ma tylko potwierdzić tożsamość; nie zastępuje weryfikacji lokalnego PIN-u/hasła.
  Future<void> triggerBiometricAuth({bool isAutoPrompt = false}) async {
    final securityState = ref.read(securityServiceProvider);
    if (!securityState.isBiometricEnabled || !securityState.canUseBiometrics) {
      return;
    }

    if (_isBiometricPromptInProgress) {
      return;
    }

    if (isAutoPrompt && _hasAttemptedAutoBiometrics) {
      return;
    }

    _isBiometricPromptInProgress = true;
    if (isAutoPrompt) {
      _hasAttemptedAutoBiometrics = true;
    }

    try {
      final localAuth = ref.read(localAuthProvider);
      final authenticated = await localAuth.authenticate(
        localizedReason: 'Zautoryzuj się, aby odblokować aplikację',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );

      if (!authenticated) {
        // _log.w(
        //   '[PIN-VERIFICATION] Biometria odrzucona lub nie została potwierdzona. Ekran blokady pozostaje aktywny.',
        // );
        state = const PinVerificationState.error();
        return;
      }

      final sessionValid = await ref
          .read(authControllerProvider.notifier)
          .unlockWithPinAndValidateSession();

      if (!sessionValid) {
        // _log.w(
        //   '[PIN-VERIFICATION] Biometria potwierdziła tożsamość, ale sesja nie została odblokowana. Ekran blokady pozostaje aktywny.',
        // );
        state = const PinVerificationState.error();
        return;
      }

      await ref.read(securityServiceProvider.notifier).unlockApp();
      state = const PinVerificationState.success();
      // _log.i('[PIN-VERIFICATION] Biometria zakończona sukcesem. Ekran blokady został zamknięty.');
    } on PlatformException catch (e) {
      final code = e.code;
      if (code == 'userCanceled' || code == 'UserCanceled') {
        // _log.i('[PIN-VERIFICATION] Anulowanie biometrii przez użytkownika. Zostawiam ekran blokady.');
        state = const PinVerificationState.error();
        return;
      }
      // _log.w(
      //   '[PIN-VERIFICATION] PlatformException podczas biometrii: ${e.code}',
      //   error: e,
      // );
      state = const PinVerificationState.error();
    } on LocalAuthException catch (e) {
      final isCanceled = e.code == LocalAuthExceptionCode.userCanceled ||
          e.code == LocalAuthExceptionCode.systemCanceled;

      if (isCanceled) {
        // _log.i('[PIN-VERIFICATION] LocalAuthException userCanceled. Ekran blokady pozostaje aktywny.');
        state = const PinVerificationState.error();
        return;
      }
      _log.w(
        '[PIN-VERIFICATION] LocalAuthException podczas biometrii: ${e.code} ${e.description ?? ""}',
        error: e,
      );
      state = const PinVerificationState.error();
    } catch (e, st) {
      _log.w('Błąd autoryzacji biometrycznej', error: e, stackTrace: st);
      state = const PinVerificationState.error();
    } finally {
      _isBiometricPromptInProgress = false;
    }
  }

  Future<void> verifyLocalSecret({
    required LocalSecurityMethod method,
    required List<int> secretBytes,
  }) async {
    state = const PinVerificationState.loading();

    final ok = await ref.read(pinServiceProvider).verifyLocalSecret(
      method: method,
      secretBytes: secretBytes,
    );
    if (!ok) {
      _log.w(
        '[PIN-VERIFICATION] Nieudana weryfikacja lokalnego sekretu w PinService dla metody $method.',
      );
      await _handleFailedAttempt();
      return;
    }

    final storage = ref.read(secureStorageProvider);
    final saltBase64 = await storage.read(key: StorageKeys.kekSalt);

    if (saltBase64 == null || saltBase64.isEmpty) {
      // _log.e('[PIN-VERIFICATION] Brak kek_salt w SecureStorage!');
      state = const PinVerificationState.error();
      return;
    }

    try {
      final salt = base64Decode(saltBase64);
      await ref.read(cryptoServiceProvider.notifier).loadAndUnlockPrivateKey(
        pinBytes: secretBytes,
        salt: salt,
      );
    } catch (e, st) {
      _log.e(
        '[PIN-VERIFICATION] Błąd odszyfrowywania klucza prywatnego!',
        error: e,
        stackTrace: st,
      );
      state = const PinVerificationState.error();
      return;
    }

    state = const PinVerificationState.success();

    final sessionValid = await ref
        .read(authControllerProvider.notifier)
        .unlockWithPinAndValidateSession();

    if (!sessionValid) {
      _log.w(
        '[PIN-VERIFICATION] Brak połączenia z serwerem po poprawnym lokalnym sekrecie. Zachowano odblokowanie lokalne.',
      );
      return;
    }

    _log.i(
      '✅ [PIN-VERIFICATION] Proces weryfikacji lokalnego sekretu zakończony sukcesem.',
    );
  }

  Future<void> verifyPin(List<int> pinCodes) async {
    await verifyLocalSecret(
      method: LocalSecurityMethod.pin,
      secretBytes: pinCodes,
    );
  }

  Future<void> verifyPassword(String password) async {
    await verifyLocalSecret(
      method: LocalSecurityMethod.password,
      secretBytes: utf8.encode(password),
    );
  }

  Future<void> _handleFailedAttempt() async {
    await ref.read(pinAttemptLimiterProvider.notifier).registerFailedAttempt();
    final updatedLimiter = ref.read(pinAttemptLimiterProvider).value;

    if (updatedLimiter != null && updatedLimiter.isLocked) {
      final now = ref.read(backendStateProvider.notifier).getSafeNow();
      final initialRemaining = updatedLimiter.lockUntil!.difference(now);

      state = PinVerificationState.locked(remaining: initialRemaining);
      _startLockoutTimer(updatedLimiter.lockUntil!);

      _log.w('Aplikacja zablokowana na: ${initialRemaining.inSeconds}s');
    } else {
      state = const PinVerificationState.error();
      final remaining = ref
          .read(pinAttemptLimiterProvider.notifier)
          .remainingAttempts;
      _log.w(
        'Błędny PIN. Pozostałe próby: $remaining / ${PinAttemptLimiter.maxAttemptsBeforeLock}',
      );
    }
  }

  void _startLockoutTimer(DateTime lockUntil) {
    _lockoutTimer?.cancel();
    final backendNotifier = ref.read(backendStateProvider.notifier);

    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final now = backendNotifier.getSafeNow();
      final remaining = lockUntil.difference(now);

      if (remaining.inSeconds <= 0) {
        timer.cancel();
        _lockoutTimer = null;
        await ref.read(pinAttemptLimiterProvider.notifier).reset();
        state = const PinVerificationState.idle();
      } else {
        state = PinVerificationState.locked(remaining: remaining);
      }
    });
  }
}