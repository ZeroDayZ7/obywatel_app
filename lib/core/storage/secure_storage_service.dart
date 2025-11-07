import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  /// Write a string value to secure storage
  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  /// Read a string value from secure storage
  Future<String?> read({required String key}) async {
    return _storage.read(key: key);
  }

  /// Delete a value from secure storage
  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  /// Read all key-value pairs from secure storage
  Future<Map<String, String>> readAll() async {
    final all = await _storage.readAll();
    return all;
  }

  /// Clear all values from secure storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Debug: print all key-value pairs in secure storage
  Future<void> debugPrintAll() async {
    final all = await _storage.readAll();
    if (all.isEmpty) {
      debugPrint('SecureStorage: no entries.');
    } else {
      debugPrint('SecureStorage contains ${all.length} entries:');
      all.forEach((key, value) {
        debugPrint('$key: $value');
      });
    }
  }
}
