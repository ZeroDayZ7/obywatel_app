import 'dart:convert';

import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/auth/domain/auth_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_service.g.dart';

@Riverpod(keepAlive: true)
SessionService sessionService(Ref ref) {
  return SessionService(
    ref.watch(secureStorageProvider),
    ref.watch(appLoggerProvider),
  );
}

class SessionService {
  final SecureStorageService _storage;
  final AppLogger _logger;

  SessionService(this._storage, this._logger);

  /// Zapisuje na dysku token odświeżania.
  Future<void> saveSession({required String refreshToken}) async {
    try {
      await _storage.write(key: StorageKeys.refreshToken, value: refreshToken);
    } catch (e, st) {
      _logger.e('Failed to save session', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Zapisuje profil użytkownika jako zmapowany JSON String.
  Future<void> cacheUser(AuthUser user) async {
    try {
      final jsonString = jsonEncode(user.toJson());
      await _storage.write(key: StorageKeys.userProfile, value: jsonString);
      _logger.d('User profile successfully cached in SecureStorage');
    } catch (e, st) {
      _logger.e('Failed to cache user profile', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Odczytuje i deserializuje profil użytkownika z SecureStorage.
  Future<AuthUser?> getCachedUser() async {
    try {
      final jsonString = await _storage.read(key: StorageKeys.userProfile);
      if (jsonString == null || jsonString.isEmpty) {
        return null;
      }
      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return AuthUser.fromJson(jsonMap);
    } catch (e, st) {
      _logger.e(
        'Failed to read or parse cached user profile',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: StorageKeys.refreshToken);
  }

  /// Czyszczenie sesji i pamięci podręcznej profilu przy wylogowaniu.
  Future<void> clearSession() async {
    try {
      await Future.wait([
        _storage.delete(key: StorageKeys.refreshToken),
        _storage.delete(key: StorageKeys.userProfile),
      ]);
      _logger.i('Session and cached user profile cleared successfully');
    } catch (e, st) {
      _logger.e(
        'Critical error while clearing session',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }
}
