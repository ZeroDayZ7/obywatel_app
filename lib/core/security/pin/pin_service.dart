import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:obywatel_plus/core/crypto/hash_service.dart';
import 'package:obywatel_plus/core/crypto/kdf_service.dart';
import 'package:obywatel_plus/core/crypto/symmetric_crypto.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/cryptography/secure_buffer.dart';
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

/// Serwis obsługi PIN
class PinService {
  /// Flaga ręcznego włączania/wyłączania szczegółowych logów debugowych w tym pliku.
  static const bool _enableVerboseLogging = false;

  final SecureStorageService _storage;
  final HashService _hashService;
  final KdfService _kdfService;
  final SymmetricCrypto _crypto;
  final AppLogger _logger;

  SecretKey? _sessionKey;

  bool get isUnlocked => _sessionKey != null;

  PinService({
    required SecureStorageService storage,
    required HashService hashService,
    required KdfService kdfService,
    required SymmetricCrypto crypto,
    required DeviceInfoService deviceInfoService,
    required AppLogger logger,
  })  : _storage = storage,
        _hashService = hashService,
        _kdfService = kdfService,
        _crypto = crypto,
        _logger = logger;

  void _logDebug(String message) {
    if (_enableVerboseLogging) {
      _logger.d(message);
    }
  }

  // ---------------------------------------------------------------------------
  // INIT / SET PIN
  // ---------------------------------------------------------------------------

  Future<void> initializeSecurity(List<int> pinBytes) async {
    _logger.i('[PIN-SERVICE] Inicjalizacja zabezpieczeń PIN...');
    final localCopy = List<int>.from(pinBytes);
    try {
      await setPin(localCopy);
      _logger.i('[PIN-SERVICE] PIN ustawiony poprawnie.');
    } finally {
      _wipe(localCopy);
    }
  }

  Future<void> setPin(List<int> pinCodes) async {
    _validatePinList(pinCodes);

    final localCopy = List<int>.from(pinCodes);
    final buffer = SecureBuffer(localCopy.length);
    try {
      for (int i = 0; i < localCopy.length; i++) {
        buffer.view[i] = localCopy[i];
      }

      final hash = await _hashService.hash(buffer.view);
      await _storage.write(key: StorageKeys.pinHash, value: hash);
      _logger.i('[PIN-SERVICE] Hash PIN-u pomyślnie zapisany.');
    } finally {
      buffer.dispose();
      _wipe(localCopy);
    }
  }

  // ---------------------------------------------------------------------------
  // VERIFY / UNLOCK
  // ---------------------------------------------------------------------------

  Future<bool> verifyPin(List<int> pinCodes) async {
    _logger.i('[PIN-SERVICE] Weryfikacja PIN...');
    _logDebug('[PIN-SERVICE] Długość PIN: ${pinCodes.length}');

    _validatePinList(pinCodes);

    final workingCopy = List<int>.from(pinCodes);
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
        _logger.w('[PIN-SERVICE] Hash PIN-u niepoprawny.');
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

      _logger.i('✅ [PIN-SERVICE] PIN poprawny, sesja odblokowana.');
      return true;
    } catch (e, st) {
      _logger.e(
        '❌ [PIN-SERVICE] Błąd weryfikacji PIN-u!',
        error: e,
        stackTrace: st,
      );
      rethrow;
    } finally {
      buffer.dispose();
      _wipe(workingCopy);
    }
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
    await _storage.delete(key: StorageKeys.pinHash);
    _logger.i('[PIN-SERVICE] PIN usunięty');
  }

  void _validatePinList(List<int> pinCodes) {
    if (pinCodes.length < 4 || pinCodes.length > 6) {
      throw PinValidationException('errors.pin_invalid_length');
    }

    for (final c in pinCodes) {
      if (c < 0 || c > 9) {
        throw PinValidationException('errors.pin_not_numeric');
      }
    }
  }

  void _wipe(List<int> data) {
    for (int i = 0; i < data.length; i++) {
      data[i] = 0;
    }
  }
}