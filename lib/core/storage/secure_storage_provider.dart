import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage_provider.g.dart';

@riverpod
SecureStorageService secureStorage(Ref ref) {
  final logger = ref.watch(appLoggerProvider);
  return SecureStorageService(const FlutterSecureStorage(), logger);
}

class SecureStorageService {
  final FlutterSecureStorage _storage;
  final AppLogger _logger;

  SecureStorageService(this._storage, this._logger);

  /// Write a string value to secure storage
  Future<void> write({required String key, required String value}) async {
    try {
      await _storage.write(key: key, value: value);
      // Logujemy klucz i wartość
      _logger.d('SecureStorage: wrote key "$key" with value: $value');
    } catch (e, st) {
      _logger.e(
        'SecureStorage: failed to write key "$key"',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Read a string value from secure storage
  Future<String?> read({required String key}) async {
    try {
      final result = await _storage.read(key: key);
      _logger.d(
        'SecureStorage: read key "$key", value present: ${result != null}',
      );
      return result;
    } catch (e, st) {
      _logger.e(
        'SecureStorage: failed to read key "$key"',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Delete a value from secure storage
  Future<void> delete({required String key}) async {
    try {
      await _storage.delete(key: key);
      _logger.d('SecureStorage: deleted key "$key"');
    } catch (e, st) {
      _logger.e(
        'SecureStorage: failed to delete key "$key"',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Read all key-value pairs from secure storage
  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }

  /// Clear all values from secure storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Debug: print all key-value pairs using AppLogger
  Future<void> debugPrintAll() async {
    final all = await _storage.readAll();
    if (all.isEmpty) {
      _logger.d(
        '===== SecureStorage: no entries. =====',
        module: 'SecureStorage',
      );
    } else {
      _logger.d(
        '===== SecureStorage contains ${all.length} entries =====',
        module: 'SecureStorage',
      );
      all.forEach((key, value) {
        _logger.d('• $key: $value', module: 'SecureStorage');
      });
    }
  }
}
