import 'dart:async';
import 'dart:convert';

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
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pin_verification_notifier.g.dart';

@Riverpod(keepAlive: true)
class PinVerificationNotifier extends _$PinVerificationNotifier {
  Timer? _lockoutTimer;
  bool _hasAttemptedAutoBiometrics = false;

  AppLogger get _log => ref.read(appLoggerProvider);

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

  /// Wyzwalanie autoryzacji biometrycznej przeniesione do Notifiera
  Future<void> triggerBiometricAuth({bool isAutoPrompt = false}) async {
    if (isAutoPrompt && _hasAttemptedAutoBiometrics) return;

    final securityState = ref.read(securityServiceProvider);
    if (!securityState.isBiometricEnabled || !securityState.canUseBiometrics) {
      return;
    }

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

      if (authenticated) {
        await ref.read(securityServiceProvider.notifier).unlockApp();
      }
    } catch (e, st) {
      _log.w('Błąd autoryzacji biometrycznej', error: e, stackTrace: st);
    }
  }

  Future<void> verifyPin(List<int> pinCodes) async {
    state = const PinVerificationState.loading();

    // 1. PinService weryfikuje hash PIN-u oraz testuje odszyfrowanie sessionKey
    final ok = await ref.read(pinServiceProvider).verifyPin(pinCodes);

    if (!ok) {
      await _handleFailedAttempt();
      return;
    }

    // 2. Odczytaj salt z SecureStorage
    final storage = ref.read(secureStorageProvider);
    final saltBase64 = await storage.read(key: StorageKeys.kekSalt);

    if (saltBase64 != null && saltBase64.isNotEmpty) {
      try {
        final salt = base64Decode(saltBase64);

        // ⚡ POPRAWKA: Przekazujemy surowe pinCodes [1, 2, 3, 4] do KDF,
        // bo dokładnie takimi samymi bajtami szyfrowaliśmy w completeSetup!
        await ref
            .read(cryptoServiceProvider.notifier)
            .loadAndUnlockPrivateKey(pinBytes: pinCodes, salt: salt);
      } catch (e, st) {
        _log.e(
          'Błąd odszyfrowywania klucza prywatnego PIN-em',
          error: e,
          stackTrace: st,
        );
        state = const PinVerificationState.error();
        return;
      }
    }

    // 3. Emitujemy success po załadowaniu klucza do RAM
    state = const PinVerificationState.success();

    // 4. Przechodzimy do weryfikacji sesji
    final sessionValid = await ref
        .read(authControllerProvider.notifier)
        .unlockWithPinAndValidateSession();

    if (!sessionValid) {
      _log.w(
        'Sesja nieprawidłowa po podaniu PIN-u. Przekierowanie do logowania.',
      );
      state = const PinVerificationState.error();
    }
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
