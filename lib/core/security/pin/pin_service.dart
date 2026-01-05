import 'package:obywatel_plus/core/crypto/hash_service.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/cryptography/secure_buffer.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pin_service.g.dart';

@Riverpod(keepAlive: true)
PinService pinService(Ref ref) {
  return PinService(
    storage: ref.watch(secureStorageProvider),
    hashService: ref.watch(hashServiceProvider),
    logger: ref.watch(appLoggerProvider),
  );
}

/// Wyjątek dla nieprawidłowego PIN-u
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
  final AppLogger _logger;

  PinService({
    required SecureStorageService storage,
    required HashService hashService,
    required AppLogger logger,
  }) : _storage = storage,
       _hashService = hashService,
       _logger = logger;

  /// Ustawia PIN: waliduje, hashuje i zeruje pamięć RAM
  Future<void> setPin(List<int> pinCodes) async {
    _logger.d('PinService: Ustawianie PIN (Secure Flow)');

    // 1. Walidacja (na poziomie bajtów/intów)
    _validatePinList(pinCodes);

    // 2. Alokacja bezpiecznego bufora przez FFI
    final buffer = SecureBuffer(pinCodes.length);

    try {
      // 3. Kopiowanie danych do natywnego RAMu
      for (int i = 0; i < pinCodes.length; i++) {
        buffer.view[i] = pinCodes[i];
      }

      // 4. Hashowanie bezpośrednio z bufora
      final hashed = await _hashService.hash(buffer.view);

      // 5. Zapisujemy tylko HASH
      await _storage.write(key: StorageKeys.pinHash, value: hashed);
    } catch (e) {
      rethrow;
    } finally {
      buffer.dispose();

      for (int i = 0; i < pinCodes.length; i++) {
        pinCodes[i] = 0;
      }
    }
  }

  /// Weryfikuje PIN: używa natywnego bufora i czyści go po operacji
  Future<bool> verifyPin(List<int> pinCodes) async {
    _logger.d('PinService: Weryfikacja PIN (Secure Flow)');

    if (pinCodes.isEmpty) return false;

    final buffer = SecureBuffer(pinCodes.length);

    try {
      for (int i = 0; i < pinCodes.length; i++) {
        buffer.view[i] = pinCodes[i];
      }

      final storedHash = await _storage.read(key: StorageKeys.pinHash);
      if (storedHash == null) return false;

      final isValid = await _hashService.verify(buffer.view, storedHash);

      return isValid;
    } catch (e, s) {
      _logger.e('PinService: Błąd weryfikacji', error: e, stackTrace: s);
      return false;
    } finally {
      buffer.dispose();
      for (int i = 0; i < pinCodes.length; i++) {
        pinCodes[i] = 0;
      }
    }
  }

  /// Prywatna metoda walidacji listy kodów PIN
  void _validatePinList(List<int> pinCodes) {
    if (pinCodes.length < 4 || pinCodes.length > 6) {
      // POPRAWKA: Używamy PinValidationException zamiast niezdefiniowanego AppException
      throw PinValidationException('errors.pin_invalid_length');
    }
    // Dodatkowe sprawdzenie, czy to same cyfry (ASCII 48-57)
    for (var code in pinCodes) {
      if (code < 48 || code > 57) {
        throw PinValidationException('errors.pin_not_numeric');
      }
    }
  }

  /// Sprawdza, czy PIN jest ustawiony
  Future<bool> hasPin() async {
    final storedHash = await _storage.read(key: StorageKeys.pinHash);
    final has = storedHash != null && storedHash.isNotEmpty;
    return has;
  }

  /// Usuwa PIN
  Future<void> removePin() async {
    await _storage.delete(key: StorageKeys.pinHash);
    _logger.i('PinService: PIN został usunięty z pamięci bezpiecznej');
  }
}
