// lib/core/security/pin_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:obywatel_plus/app/config/storage_keys.dart';
import 'package:obywatel_plus/core/crypto/hash_service.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

class PinService {
  final FlutterSecureStorage _storage;
  final HashService _hashService;
  final AppLogger _logger;

  PinService({
    required FlutterSecureStorage storage,
    required HashService hashService,
    required AppLogger logger,
  }) : _storage = storage,
       _hashService = hashService,
       _logger = logger;

  /// Ustawia PIN: waliduje (4-6 cyfr), hashuje, zapisuje w secure storage
  Future<void> setPin(String pin) async {
    _logger.d('PinService: Ustawianie PIN (długość: ${pin.length})');

    if (pin.isEmpty || !RegExp(r'^\d{4,6}$').hasMatch(pin)) {
      _logger.w('PinService: Nieprawidłowy PIN – musi być 4-6 cyfr');
      throw ArgumentError('PIN musi być liczbą 4-6 cyfr, ziomek!');
    }

    try {
      final hashed = await _hashService.hash(pin);
      await _storage.write(key: StorageKeys.pinHash, value: hashed);
      _logger.i('PinService: PIN ustawiony pomyślnie');
    } catch (e, s) {
      _logger.e('PinService: Błąd ustawiania PIN', error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Sprawdza PIN: czyta z storage, verify z hashem
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

  /// Czy PIN jest ustawiony?
  Future<bool> hasPin() async {
    final storedHash = await _storage.read(key: StorageKeys.pinHash);
    final has = storedHash != null && storedHash.isNotEmpty;
    _logger.d('PinService: PIN ustawiony? $has');
    return has;
  }

  /// Usuń PIN (np. na skip lub reset)
  Future<void> deletePin() async {
    await _storage.delete(key: StorageKeys.pinHash);
    _logger.i('PinService: PIN usunięty');
  }
}
