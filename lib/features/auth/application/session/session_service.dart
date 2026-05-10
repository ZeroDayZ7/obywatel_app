import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_service.g.dart';

@Riverpod(keepAlive: true)
SessionService sessionService(Ref ref) {
  return SessionService(
    ref.watch(secureStorageProvider),
    ref.watch(appLoggerProvider),
  );
}

typedef SessionData = ({String accessToken, String userId});

class SessionService {
  final SecureStorageService _storage;
  final AppLogger _logger;

  SessionService(this._storage, this._logger);

  Future<SessionData?> getSessionDetails() async {
    try {
      final results = await Future.wait([
        _storage.read(key: StorageKeys.accessToken),
        _storage.read(key: StorageKeys.userId),
      ]);

      final token = results[0];
      final userId = results[1];

      if (token == null || token.isEmpty || userId == null || userId.isEmpty) {
        return null;
      }

      return (accessToken: token, userId: userId);
    } catch (e, st) {
      _logger.e('Failed to fetch session details', error: e, stackTrace: st);
      return null;
    }
  }

  Future<String?> getAccessToken() async {
    return _storage.read(key: StorageKeys.accessToken);
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: StorageKeys.refreshToken);
  }

  Future<String?> getUserId() async {
    final rawId = await _storage.read(key: StorageKeys.userId);
    if (rawId == null || rawId.isEmpty) return null;
    return rawId;
  }

  Future<void> updateTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      await Future.wait([
        _storage.write(key: StorageKeys.accessToken, value: accessToken),
        _storage.write(key: StorageKeys.refreshToken, value: refreshToken),
      ]);
      _logger.d('Tokens updated successfully');
    } catch (e, st) {
      _logger.e('Failed to update tokens', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String userId,
  }) async {
    try {
      await Future.wait([
        _storage.write(key: StorageKeys.accessToken, value: accessToken),
        _storage.write(key: StorageKeys.refreshToken, value: refreshToken),
        _storage.write(key: StorageKeys.userId, value: userId),
      ]);
      _logger.i('Session saved for user: $userId');
    } catch (e, st) {
      _logger.e('Failed to save session', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> clearSession() async {
    try {
      await Future.wait([
        _storage.delete(key: StorageKeys.accessToken),
        _storage.delete(key: StorageKeys.refreshToken),
        _storage.delete(key: StorageKeys.userId),
      ]);
      _logger.i('Session cleared successfully');
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
