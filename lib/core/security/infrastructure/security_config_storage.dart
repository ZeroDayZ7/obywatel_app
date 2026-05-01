import 'dart:convert';

import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/core/security/domain/auth_method.dart';
import 'package:obywatel_plus/core/security/domain/security_config.dart';

abstract class SecurityConfigStorage {
  Future<SecurityConfig?> load();
  Future<void> save(SecurityConfig config);
  Future<void> clear();
}

class SecurityConfigStorageImpl implements SecurityConfigStorage {
  final SecureStorageService _secureStorage;

  SecurityConfigStorageImpl(this._secureStorage);

  @override
  Future<SecurityConfig?> load() async {
    final raw = await _secureStorage.read(key: StorageKeys.securityConfig);

    if (raw == null) return null;

    final json = jsonDecode(raw) as Map<String, dynamic>;

    return SecurityConfig(
      method: AuthMethod.values.firstWhere(
        (e) => e.name == json['method'] as String,
      ),
      failedAttempts:
          (json['failedAttempts'] as int?) ??
          0,
      lockUntil: json['lockUntil'] != null
          ? DateTime.parse(
              json['lockUntil'] as String,
            )
          : null,
    );
  }

  @override
  Future<void> save(SecurityConfig config) {
    final json = jsonEncode({
      'method': config.method.name,
      'failedAttempts': config.failedAttempts,
      'lockUntil': config.lockUntil?.toIso8601String(),
    });

    return _secureStorage.write(key: StorageKeys.securityConfig, value: json);
  }

  @override
  Future<void> clear() {
    return _secureStorage.delete(key: StorageKeys.securityConfig);
  }
}
