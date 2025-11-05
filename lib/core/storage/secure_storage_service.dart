// lib/core/storage/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService(this._storage);

  Future<void> write({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read({required String key}) async {
    return _storage.read(key: key);
  }

  Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  Future<Map<String, String>> readAll() async {
    final all = await _storage.readAll();
    return all;
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// 🔍 Wypisuje wszystkie klucze i wartości w storage
  Future<void> debugPrintAll() async {
    final all = await _storage.readAll();
    if (all.isEmpty) {
      debugPrint('🔒 SecureStorage: brak zapisanych danych.');
    } else {
      debugPrint('🔒 SecureStorage zawiera ${all.length} wpisów:');
      all.forEach((key, value) {
        debugPrint('• $key: $value');
      });
    }
  }
}
