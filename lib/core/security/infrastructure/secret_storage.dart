import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';

abstract class SecretStorage {
  Future<void> save(String hash);
  Future<String?> load();
  Future<void> clear();
}

class SecretStorageImpl implements SecretStorage {
  final SecureStorageService _secureStorage;

  SecretStorageImpl(this._secureStorage);

  @override
  Future<void> save(String hash) {
    return _secureStorage.write(key: StorageKeys.securitySecret, value: hash);
  }

  @override
  Future<String?> load() {
    return _secureStorage.read(key: StorageKeys.securitySecret);
  }

  @override
  Future<void> clear() {
    return _secureStorage.delete(key: StorageKeys.securitySecret);
  }
}
