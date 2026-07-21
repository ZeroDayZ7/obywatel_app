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

class SessionService {
  final SecureStorageService _storage;
  final AppLogger _logger;

  SessionService(this._storage, this._logger);

  /// Zapisuje na dysku wyłącznie refresh token oraz userId
  Future<void> saveSession({required String refreshToken}) async {
    try {
      await Future.wait([
        _storage.write(key: StorageKeys.refreshToken, value: refreshToken),
      ]);
    } catch (e, st) {
      _logger.e('Failed to save session', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: StorageKeys.refreshToken);
  }

  Future<String?> getUserId() async {
    final rawId = await _storage.read(key: StorageKeys.userId);
    if (rawId == null || rawId.isEmpty) return null;
    return rawId;
  }

  Future<void> clearSession() async {
    try {
      await Future.wait([
        _storage.delete(key: StorageKeys.refreshToken),
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
