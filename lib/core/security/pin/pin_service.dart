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
  }) : _storage = storage,
       _hashService = hashService,
       _kdfService = kdfService,
       _crypto = crypto,
       _logger = logger;

  // ---------------------------------------------------------------------------
  // INIT / SET PIN
  // ---------------------------------------------------------------------------

  Future<void> initializeSecurity(List<int> pinBytes) async {
    _logger.i('[PIN-SERVICE][INIT] Inicjalizacja zabezpieczeń PIN...');
    final localCopy = List<int>.from(pinBytes);
    try {
      await setPin(localCopy);
      _logger.i('[PIN-SERVICE][INIT] PIN ustawiony poprawnie.');
    } finally {
      _wipe(localCopy);
    }
  }

  Future<void> setPin(List<int> pinCodes) async {
    _logger.i(
      '[PIN-SERVICE][SET-PIN][1] Walidacja i zapisywanie nowego PIN...',
    );
    _validatePinList(pinCodes);

    final localCopy = List<int>.from(pinCodes);
    final buffer = SecureBuffer(localCopy.length);
    try {
      for (int i = 0; i < localCopy.length; i++) {
        buffer.view[i] = localCopy[i]; // 0–9 bez ASCII
      }

      final hash = await _hashService.hash(buffer.view);
      await _storage.write(key: StorageKeys.pinHash, value: hash);
      _logger.i(
        '[PIN-SERVICE][SET-PIN][2] Hash PIN-u pomyślnie zapisany w SecureStorage.',
      );
    } finally {
      buffer.dispose();
      _wipe(localCopy);
    }
  }

  // ---------------------------------------------------------------------------
  // VERIFY / UNLOCK
  // ---------------------------------------------------------------------------

  Future<bool> verifyPin(List<int> pinCodes) async {
    _logger.i(
      '[VERIFY-PIN-SERVICE][1] Rozpoczynam weryfikację PIN-u w PinService...',
    );
    _logger.d(
      '[VERIFY-PIN-SERVICE][1.1] Parametr wejściowy pinCodes: $pinCodes (len: ${pinCodes.length})',
    );

    _validatePinList(pinCodes);

    // Kopia robocza, zapobiegająca wyzerowaniu oryginalnej listy u callera
    final workingCopy = List<int>.from(pinCodes);
    final buffer = SecureBuffer(workingCopy.length);
    _logger.d(
      '[VERIFY-PIN-SERVICE][1.2] Utworzono SecureBuffer o rozmiarze: ${workingCopy.length}',
    );

    try {
      // 2. Kopiowanie bajtów do SecureBuffer
      _logger.i(
        '[VERIFY-PIN-SERVICE][2] Kopiuję bajty PIN do SecureBuffer.view...',
      );
      for (int i = 0; i < workingCopy.length; i++) {
        buffer.view[i] = workingCopy[i]; // 0–9, bez +48
      }
      _logger.d(
        '[VERIFY-PIN-SERVICE][2.1] Zawartość buffer.view: ${buffer.view}',
      );

      // 3. Odczyt zapisanego hashu z SecureStorage
      _logger.i(
        '[VERIFY-PIN-SERVICE][3] Odczytuję pin_hash z SecureStorage...',
      );
      final storedHash = await _storage.read(key: StorageKeys.pinHash);
      _logger.d(
        '[VERIFY-PIN-SERVICE][3.1] Odczytany storedHash: '
        '${storedHash != null ? "PRESENT (len: ${storedHash.length})" : "NULL"}',
      );

      if (storedHash == null) {
        _logger.e(
          '[VERIFY-PIN-SERVICE][ERR] Brak zapisanego pin_hash w SecureStorage!',
        );
        return false;
      }

      // 4. Weryfikacja hashu
      _logger.i(
        '[VERIFY-PIN-SERVICE][4] Weryfikuję PIN za pomocą _hashService.verify...',
      );
      final valid = await _hashService.verify(buffer.view, storedHash);
      _logger.d(
        '[VERIFY-PIN-SERVICE][4.1] Wynik weryfikacji hashu (valid): $valid',
      );

      if (!valid) {
        _logger.w('[VERIFY-PIN-SERVICE][4.2] Hash PIN-u niepoprawny.');
        return false;
      }

      // 5. Odczyt soli oraz zaszyfrowanego klucza prywatnego
      _logger.i(
        '[VERIFY-PIN-SERVICE][5] Odczytuję kek_salt oraz device_private_key_enc z SecureStorage...',
      );
      final saltBase64 = await _storage.read(key: StorageKeys.kekSalt);
      final encryptedMasterKey = await _storage.read(
        key: StorageKeys.devicePrivateKey,
      );

      _logger.d(
        '[VERIFY-PIN-SERVICE][5.1] Status kluczy w storage: '
        'saltBase64=${saltBase64 != null ? "PRESENT" : "NULL"}, '
        'encryptedMasterKey=${encryptedMasterKey != null ? "PRESENT" : "NULL"}',
      );

      if (saltBase64 == null || encryptedMasterKey == null) {
        _logger.e(
          '[VERIFY-PIN-SERVICE][ERR] Brak soli lub zaszyfrowanego klucza w SecureStorage!',
        );
        return false;
      }

      // 6. Dekodowanie soli i odblokowanie sesji
      _logger.i(
        '[VERIFY-PIN-SERVICE][6] Dekoduję sól z Base64 i wywołuję _unlockSession...',
      );
      final salt = base64Decode(saltBase64);
      _logger.d(
        '[VERIFY-PIN-SERVICE][6.1] Zdekodowano salt. Długość: ${salt.length} bajtów',
      );

      await _unlockSession(
        pin: buffer.view,
        salt: salt,
        encryptedMasterKey: encryptedMasterKey,
      );

      _logger.i(
        '✅ [VERIFY-PIN-SERVICE][7] Weryfikacja PIN-u oraz odblokowanie sesji zakończone sukcesem.',
      );
      return true;
    } catch (e, st) {
      _logger.e(
        '❌ [VERIFY-PIN-SERVICE][ERR] Wystąpił błąd podczas weryfikacji PIN-u!',
        error: e,
        stackTrace: st,
      );
      rethrow;
    } finally {
      _logger.i(
        '[VERIFY-PIN-SERVICE][8] Blok finally: Czyszczenie pamięci roboczej...',
      );
      _logger.d('[VERIFY-PIN-SERVICE][8.1] Zwalniam SecureBuffer...');
      buffer.dispose();

      _logger.d(
        '[VERIFY-PIN-SERVICE][8.2] Wykonuję _wipe na lokalnej kopii workingCopy.',
      );
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
    _logger.i('Sesja odblokowana');
  }

  void lock() {
    _sessionKey = null;
    _logger.i('Sesja zablokowana');
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
    _logger.i('PIN usunięty');
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
