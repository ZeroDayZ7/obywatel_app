import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:obywatel_plus/core/crypto/crypto_service.dart';
import 'package:obywatel_plus/core/crypto/hash_service.dart';
import 'package:obywatel_plus/core/crypto/kdf_service.dart';
import 'package:obywatel_plus/core/crypto/symmetric_crypto.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/cryptography/secure_buffer.dart';
import 'package:obywatel_plus/core/security/pin/local_secret_validator.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_state.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pin_service.g.dart';

@Riverpod(keepAlive: true)
PinService pinService(Ref ref) {
  return PinService(
    storage: ref.watch(secureStorageProvider),
    hashService: ref.watch(hashServiceProvider),
    kdfService: ref.watch(kdfServiceProvider),
    crypto: ref.watch(symmetricCryptoProvider),
    cryptoService: ref.watch(cryptoServiceProvider.notifier),
    deviceInfoService: ref.watch(deviceInfoServiceProvider),
    logger: ref.watch(appLoggerProvider),
  );
}

/// Wyjątek walidacji PIN-u
class PinValidationException implements Exception {
  final String message;
  PinValidationException(this.message);

  @override
  String toString() => 'PinValidationException: $message';
}

class SecurityConfigurationException implements Exception {
  final String message;
  const SecurityConfigurationException(this.message);

  @override
  String toString() => 'SecurityConfigurationException: $message';
}

/// Serwis obsługi PIN
class PinService {
  /// Flaga ręcznego włączania/wyłączania szczegółowych logów debugowych w tym pliku.
  // static const bool _enableVerboseLogging = false;

  final SecureStorageService _storage;
  final HashService _hashService;
  final KdfService _kdfService;
  final SymmetricCrypto _crypto;
  final CryptoService _cryptoService;
  final AppLogger _logger;

  SecretKey? _sessionKey;

  bool get isUnlocked => _sessionKey != null;

  PinService({
    required SecureStorageService storage,
    required HashService hashService,
    required KdfService kdfService,
    required SymmetricCrypto crypto,
    required CryptoService cryptoService,
    required DeviceInfoService deviceInfoService,
    required AppLogger logger,
  }) : _storage = storage,
       _hashService = hashService,
       _kdfService = kdfService,
       _crypto = crypto,
       _cryptoService = cryptoService,
       _logger = logger;

  // void _logDebug(String message) {
  //   if (_enableVerboseLogging) {
  //     _logger.d(message);
  //   }
  // }

  // ---------------------------------------------------------------------------
  // INIT / SET PIN
  // ---------------------------------------------------------------------------

  Future<void> initializeSecurity(List<int> pinBytes) async {
    // _logger.i('[PIN-SERVICE] Inicjalizacja zabezpieczeń PIN...');
    final localCopy = List<int>.from(pinBytes);
    try {
      await setPin(localCopy);
      // _logger.i('[PIN-SERVICE] PIN ustawiony poprawnie.');
    } finally {
      _wipe(localCopy);
    }
  }

  Future<void> setLocalSecret({
    required LocalSecurityMethod method,
    required List<int> secretBytes,
  }) async {
    if (method == LocalSecurityMethod.none) {
      throw PinValidationException(
        'Local security method must be either pin or password.',
      );
    }

    final validationError = LocalSecretValidator.validate(
      method: method,
      secret: secretBytes,
    );
    if (validationError != null) {
      throw PinValidationException(validationError);
    }

    final localCopy = List<int>.from(secretBytes);
    final buffer = SecureBuffer(localCopy.length);
    try {
      for (int i = 0; i < localCopy.length; i++) {
        buffer.view[i] = localCopy[i];
      }

      final hash = await _hashService.hash(buffer.view);
      await _storage.write(key: StorageKeys.pinHash, value: hash);
      await _storage.write(
        key: StorageKeys.localSecurityMethod,
        value: method.name,
      );
      // _logger.i('[PIN-SERVICE] Hash lokalnego sekretu pomyślnie zapisany.');
    } finally {
      buffer.dispose();
      _wipe(localCopy);
    }
  }

  Future<void> setPin(List<int> pinCodes) async {
    await setLocalSecret(
      method: LocalSecurityMethod.pin,
      secretBytes: pinCodes,
    );
  }

  Future<void> updateLocalSecret({
    required LocalSecurityMethod currentMethod,
    required LocalSecurityMethod targetMethod,
    required List<int> currentSecret,
    required List<int> newSecret,
  }) async {
    if (currentMethod == LocalSecurityMethod.none ||
        targetMethod == LocalSecurityMethod.none) {
      throw PinValidationException(
        'Local security method must be either pin or password.',
      );
    }

    if (currentSecret.isEmpty || newSecret.isEmpty) {
      throw PinValidationException('errors.invalid_current_secret');
    }

    final storedMethod = await readStoredLocalSecurityMethod();
    final expectedCurrentMethod = currentMethod == LocalSecurityMethod.none
        ? storedMethod
        : currentMethod;

    if (storedMethod != LocalSecurityMethod.none &&
        storedMethod != expectedCurrentMethod) {
      throw PinValidationException(
        'Requested current method does not match stored local security method.',
      );
    }

    final validCurrentSecret = await verifyLocalSecret(
      method: expectedCurrentMethod,
      secretBytes: currentSecret,
    );

    if (!validCurrentSecret) {
      throw PinValidationException('errors.invalid_current_secret');
    }

    final previousHash = await _storage.read(key: StorageKeys.pinHash);
    final previousSalt = await _storage.read(key: StorageKeys.kekSalt);
    final previousEncryptedKey = await _storage.read(
      key: StorageKeys.devicePrivateKey,
    );
    final previousMethod = storedMethod == LocalSecurityMethod.none
        ? expectedCurrentMethod
        : storedMethod;

    if (previousHash == null ||
        previousSalt == null ||
        previousEncryptedKey == null) {
      throw PinValidationException('errors.security_state_missing');
    }

    final newSecretCopy = List<int>.from(newSecret);
    final newSalt = _kdfService.generateSalt();

    try {
      await _cryptoService.finalizeAndPersist(newSecretCopy, newSalt);
      final newHash = await _hashService.hash(newSecretCopy);

      await _storage.write(
        key: StorageKeys.kekSalt,
        value: base64Encode(newSalt),
      );
      await _storage.write(key: StorageKeys.pinHash, value: newHash);
      await _storage.write(
        key: StorageKeys.localSecurityMethod,
        value: targetMethod.name,
      );

      // _logger.i(
      //   '[PIN-SERVICE] Lokalny sekret został zaktualizowany i klucz został przeopakowany zgodnie z nową metodą $targetMethod.',
      // );
    } catch (error, stackTrace) {
      _logger.e(
        '[PIN-SERVICE] Błąd podczas rotacji lokalnego sekretu. Przywracam poprzedni stan zabezpieczeń.',
        error: error,
        stackTrace: stackTrace,
      );

      if (previousSalt.isNotEmpty) {
        await _storage.write(key: StorageKeys.kekSalt, value: previousSalt);
      }
      if (previousEncryptedKey.isNotEmpty) {
        await _storage.write(
          key: StorageKeys.devicePrivateKey,
          value: previousEncryptedKey,
        );
      }
      if (previousHash.isNotEmpty) {
        await _storage.write(key: StorageKeys.pinHash, value: previousHash);
      }
      await _storage.write(
        key: StorageKeys.localSecurityMethod,
        value: previousMethod.name,
      );

      rethrow;
    } finally {
      _wipe(newSecretCopy);
    }
  }

  // ---------------------------------------------------------------------------
  // VERIFY / UNLOCK
  // ---------------------------------------------------------------------------

  Future<LocalSecurityMethod> readStoredLocalSecurityMethod() async {
    final rawMethod = await _storage.read(key: StorageKeys.localSecurityMethod);
    if (rawMethod == null || rawMethod.trim().isEmpty) {
      return LocalSecurityMethod.none;
    }

    switch (rawMethod.trim().toLowerCase()) {
      case 'pin':
        return LocalSecurityMethod.pin;
      case 'password':
        return LocalSecurityMethod.password;
      default:
        throw const SecurityConfigurationException(
          'Unknown local security method stored in secure storage.',
        );
    }
  }

  Future<bool> verifyLocalSecret({
    required LocalSecurityMethod method,
    required List<int> secretBytes,
  }) async {
    if (method == LocalSecurityMethod.none) {
      return false;
    }

    final storedMethod = await readStoredLocalSecurityMethod();
    if (storedMethod == LocalSecurityMethod.none) {
      if (method != LocalSecurityMethod.pin) {
        throw const SecurityConfigurationException(
          'Password-based local security is configured but method metadata is missing.',
        );
      }
    } else if (storedMethod != method) {
      _logger.w(
        '[PIN-SERVICE] Niezgodność metody lokalnego zabezpieczenia: stored=$storedMethod, requested=$method',
      );
      return false;
    }

    final validationError = LocalSecretValidator.validate(
      method: method,
      secret: secretBytes,
    );
    if (validationError != null) {
      throw PinValidationException(validationError);
    }

    final workingCopy = List<int>.from(secretBytes);
    final buffer = SecureBuffer(workingCopy.length);

    try {
      for (int i = 0; i < workingCopy.length; i++) {
        buffer.view[i] = workingCopy[i];
      }

      final storedHash = await _storage.read(key: StorageKeys.pinHash);
      if (storedHash == null) {
        _logger.e('[PIN-SERVICE] Brak zapisanego pin_hash!');
        return false;
      }

      final valid = await _hashService.verify(buffer.view, storedHash);
      if (!valid) {
        _logger.w('[PIN-SERVICE] Hash lokalnego sekretu niepoprawny.');
        return false;
      }

      final saltBase64 = await _storage.read(key: StorageKeys.kekSalt);
      final encryptedMasterKey = await _storage.read(
        key: StorageKeys.devicePrivateKey,
      );

      if (saltBase64 == null || encryptedMasterKey == null) {
        _logger.e('[PIN-SERVICE] Brak soli lub klucza w SecureStorage!');
        return false;
      }

      final salt = base64Decode(saltBase64);
      await _unlockSession(
        pin: buffer.view,
        salt: salt,
        encryptedMasterKey: encryptedMasterKey,
      );

      // _logger.i('✅ [PIN-SERVICE] Lokalny sekret poprawny, sesja odblokowana.');
      return true;
    } catch (e, st) {
      _logger.e(
        '❌ [PIN-SERVICE] Błąd weryfikacji lokalnego sekretu!',
        error: e,
        stackTrace: st,
      );
      rethrow;
    } finally {
      buffer.dispose();
      _wipe(workingCopy);
    }
  }

  Future<bool> verifyPin(List<int> pinCodes) async {
    final storedMethod = await readStoredLocalSecurityMethod();
    if (storedMethod == LocalSecurityMethod.password) {
      _logger.w(
        '[PIN-SERVICE] PIN verification requested while password-based local security is configured.',
      );
      return false;
    }

    return verifyLocalSecret(
      method: LocalSecurityMethod.pin,
      secretBytes: pinCodes,
    );
  }

  Future<void> _unlockSession({
    required List<int> pin,
    required List<int> salt,
    required String encryptedMasterKey,
  }) async {
    final key = await _kdfService.deriveKeyFromPin(pinBytes: pin, salt: salt);

    await _crypto.decryptBytes(
      encryptedBase64: encryptedMasterKey,
      secretKey: key,
    );

    _sessionKey = key;
  }

  void lock() {
    _sessionKey = null;
    _logger.i('[PIN-SERVICE] Sesja zablokowana');
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  Future<bool> hasPin() async {
    final storedHash = await _storage.read(key: StorageKeys.pinHash);
    return storedHash != null && storedHash.isNotEmpty;
  }

  Future<void> removePin() async {
    await Future.wait([
      _storage.delete(key: StorageKeys.pinHash),
      _storage.delete(key: StorageKeys.localSecurityMethod),
      _storage.delete(key: StorageKeys.kekSalt),
      _storage.delete(key: StorageKeys.devicePrivateKey),
      _storage.delete(key: StorageKeys.pinAttempts),
      _storage.delete(key: StorageKeys.pinLockUntil),
    ]);
    lock();
    _logger.i('[PIN-SERVICE] Lokalna konfiguracja bezpieczeństwa została usunięta');
  }

  void _wipe(List<int> data) {
    for (int i = 0; i < data.length; i++) {
      data[i] = 0;
    }
  }
}
