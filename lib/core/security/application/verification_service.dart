import 'package:obywatel_plus/core/security/pin/pin_attempt_limiter.dart';

import '../domain/auth_method.dart';
import '../domain/security_config.dart';
import '../domain/security_exceptions.dart';
import '../infrastructure/security_config_storage.dart';
import '../infrastructure/secret_storage.dart';

import '../infrastructure/local_auth_provider.dart';
import '../../crypto/hash_service.dart';

class VerificationService {
  VerificationService(
    this._configStorage,
    this._secretStorage,
    this._hashService,
    this._localAuth,
    this._attemptLimiter,
  );

  final SecurityConfigStorage _configStorage;
  final SecretStorage _secretStorage;
  final HashService _hashService;
  final LocalAuthProvider _localAuth;
  final PinAttemptLimiter _attemptLimiter;

  /// Główna metoda weryfikacji (PIN / hasło / biometria)
  /// ZWRACA true tylko przy sukcesie
  /// RZUCA wyjątki domenowe przy błędach stanu
  Future<bool> verifySecret(String input) async {
    final config = await _configStorage.load();

    if (config == null) {
      throw SecurityNotConfiguredException();
    }

    if (config.isLocked) {
      throw SecurityLockedException(config.lockUntil!);
    }

    switch (config.method) {
      case AuthMethod.pin4:
      case AuthMethod.pin6:
      case AuthMethod.password:
        return _verifyHashBasedSecret(input, config);

      case AuthMethod.biometrics:
        return _verifyBiometrics();
    }
  }

  // ─────────────────────────────────────────────
  // INTERNALS
  // ─────────────────────────────────────────────

  Future<bool> _verifyHashBasedSecret(
    String input,
    SecurityConfig config,
  ) async {
    final storedHash = await _secretStorage.load();

    if (storedHash == null) {
      throw SecuritySecretMissingException();
    }

    final isValid = await _hashService.verify(input, storedHash);

    if (isValid) {
      await _attemptLimiter.reset();
      return true;
    }

    // ❌ Błędna próba
    await _attemptLimiter.registerFailedAttempt();

    // Sprawdź czy po tej próbie nastąpił lock
    final updatedConfig = await _configStorage.load();
    if (updatedConfig?.isLocked == true) {
      throw SecurityLockedException(updatedConfig!.lockUntil!);
    }

    throw SecurityVerificationFailedException();
  }

  Future<bool> _verifyBiometrics() async {
    final success = await _localAuth.authenticate();

    if (!success) {
      throw SecurityVerificationFailedException();
    }

    return true;
  }
}
