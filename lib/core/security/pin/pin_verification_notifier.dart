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
    _log.i('[VERIFY-PIN][1] Rozpoczynam procedurę weryfikacji PIN-u.');
    _log.d(
      '[VERIFY-PIN][1.1] Długość pinCodes: ${pinCodes.length}, wartości: $pinCodes',
    );

    state = const PinVerificationState.loading();
    _log.d(
      '[VERIFY-PIN][1.2] Zmieniono stan na PinVerificationState.loading()',
    );

    // 2. PinService weryfikuje hash PIN-u oraz testuje odszyfrowanie sessionKey
    _log.i('[VERIFY-PIN][2] Wywołuję PinService.verifyPin...');
    final ok = await ref.read(pinServiceProvider).verifyPin(pinCodes);
    _log.i('[VERIFY-PIN][2.1] Wynik PinService.verifyPin: $ok');

    if (!ok) {
      _log.w(
        '[VERIFY-PIN][2.2] Weryfikacja PIN w PinService nie powiodła się. Obsługa nieudanego podejścia.',
      );
      await _handleFailedAttempt();
      return;
    }

    // 3. Odczytaj salt z SecureStorage
    _log.i('[VERIFY-PIN][3] Pobieram kek_salt z SecureStorage...');
    final storage = ref.read(secureStorageProvider);
    final saltBase64 = await storage.read(key: StorageKeys.kekSalt);
    _log.d(
      '[VERIFY-PIN][3.1] Odczytany saltBase64: ${saltBase64 != null ? "PRESENT (len: ${saltBase64.length})" : "NULL"}',
    );

    if (saltBase64 == null || saltBase64.isEmpty) {
      _log.e(
        '[VERIFY-PIN][3.2] KRITYCZNY BŁĄD: kek_salt jest pusty lub null w SecureStorage!',
      );
      state = const PinVerificationState.error();
      return;
    }

    try {
      _log.i('[VERIFY-PIN][4] Dekoduję kek_salt z Base64...');
      final salt = base64Decode(saltBase64);
      _log.d(
        '[VERIFY-PIN][4.1] Zdekodowany salt byte length: ${salt.length}, bajty (pierwsze 4): ${salt.take(4).toList()}',
      );

      _log.i(
        '[VERIFY-PIN][5] Przekazuję pinBytes i salt do loadAndUnlockPrivateKey...',
      );
      _log.d(
        '[VERIFY-PIN][5.1] Parametry wejściowe do KDF: pinBytes=$pinCodes, saltLen=${salt.length}',
      );

      await ref
          .read(cryptoServiceProvider.notifier)
          .loadAndUnlockPrivateKey(pinBytes: pinCodes, salt: salt);

      _log.i(
        '[VERIFY-PIN][5.2] Sukces: Pomyślnie odszyfrowano i załadowano klucz prywatny do RAM.',
      );
    } catch (e, st) {
      _log.e(
        '[VERIFY-PIN][ERROR] Błąd odszyfrowywania klucza prywatnego PIN-em w krokach 4-5!',
        error: e,
        stackTrace: st,
      );
      state = const PinVerificationState.error();
      return;
    }

    // 6. Emitujemy success po załadowaniu klucza do RAM
    _log.i('[VERIFY-PIN][6] Ustawiam stan na PinVerificationState.success()');
    state = const PinVerificationState.success();

    // 7. Przechodzimy do weryfikacji sesji
    _log.i(
      '[VERIFY-PIN][7] Wywołuję unlockWithPinAndValidateSession w AuthController...',
    );
    final sessionValid = await ref
        .read(authControllerProvider.notifier)
        .unlockWithPinAndValidateSession();

    _log.i(
      '[VERIFY-PIN][7.1] Wynik weryfikacji sesji sessionValid: $sessionValid',
    );

    if (!sessionValid) {
      _log.w(
        '[VERIFY-PIN][7.2] Sesja nieprawidłowa po podaniu PIN-u. Przekierowanie do stanu błędu.',
      );
      state = const PinVerificationState.error();
      _log.d(
        '[VERIFY-PIN][7.3] Zmieniono stan na PinVerificationState.error() z powodu nieprawidłowej sesji.',
      );
    } else {
      _log.i(
        '[VERIFY-PIN][8] Cały proces weryfikacji PIN zakończony sukcesem!',
      );
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
