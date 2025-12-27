import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/core/crypto/hash_service.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider dla PinService
final pinServiceProvider = Provider<PinService>((ref) {
  final storage = ref.read(secureStorageProvider);
  final hash = ref.read(hashServiceProvider);
  final logger = ref.read(appLoggerProvider);

  return PinService(storage: storage, hashService: hash, logger: logger);
});

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

  /// Waliduje PIN (4-6 cyfr)
  void _validatePin(String pin) {
    if (pin.length < 4 || pin.length > 6 || int.tryParse(pin) == null) {
      _logger.w('PinService: Nieprawidłowy PIN – musi być 4-6 cyfr');
      throw PinValidationException('PIN musi być liczbą 4-6 cyfr');
    }
  }

  /// Ustawia PIN: waliduje, hashuje, zapisuje w secure storage
  Future<void> setPin(String pin) async {
    _logger.d('PinService: Ustawianie PIN (długość: ${pin.length})');
    _validatePin(pin);

    try {
      final hashed = await _hashService.hash(pin);
      await _storage.write(key: StorageKeys.pinHash, value: hashed);
      _logger.i('PinService: PIN ustawiony pomyślnie');
    } catch (e, s) {
      _logger.e('PinService: Błąd ustawiania PIN', error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Weryfikuje PIN: czyta z storage i sprawdza hash
  Future<bool> verifyPin(String pin) async {
    _logger.d('PinService: Weryfikacja PIN');

    if (pin.isEmpty) {
      _logger.w('PinService: Pusty PIN do weryfikacji');
      return false;
    }

    try {
      final storedHash = await _storage.read(key: StorageKeys.pinHash);
      if (storedHash == null || storedHash.isEmpty) {
        _logger.w('PinService: Brak zapisanego PIN');
        return false;
      }

      final isValid = await _hashService.verify(pin, storedHash);
      _logger.i('PinService: Weryfikacja PIN: $isValid');
      return isValid;
    } catch (e, s) {
      _logger.e('PinService: Błąd weryfikacji PIN', error: e, stackTrace: s);
      return false;
    }
  }

  /// Sprawdza, czy PIN jest ustawiony
  Future<bool> hasPin() async {
    final storedHash = await _storage.read(key: StorageKeys.pinHash);
    final has = storedHash != null && storedHash.isNotEmpty;
    _logger.d('PinService: PIN ustawiony? $has');
    return has;
  }

  /// Usuwa PIN
  Future<void> deletePin() async {
    await _storage.delete(key: StorageKeys.pinHash);
    _logger.i('PinService: PIN usunięty');
  }
}
