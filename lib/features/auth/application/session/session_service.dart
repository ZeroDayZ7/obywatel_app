// features/auth/application/session/session_service.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';

class SessionService {
  final SecureStorageService _storage;

  SessionService(this._storage);

  /// Czy użytkownik ma zapisane tokeny? (Start aplikacji)
  Future<bool> hasSession() async {
    final token = await _storage.read(key: StorageKeys.accessToken);
    return token != null && token.isNotEmpty;
  }

  Future<String?> getUserId() async {
    return _storage.read(key: StorageKeys.userId);
  }

  /// Zapisz nową sesję
  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    required String userId,
  }) async {
    await _storage.write(key: StorageKeys.accessToken, value: accessToken);
    await _storage.write(key: StorageKeys.refreshToken, value: refreshToken);
    await _storage.write(key: StorageKeys.userId, value: userId);
  }

  /// Wyczyść sesję (Logout)
  Future<void> clearSession() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
    await _storage.delete(key: StorageKeys.userId);
    // Opcjonalnie: nie czyścimy PINu tutaj, tylko tokeny
  }
}

final sessionServiceProvider = Provider<SessionService>((ref) {
  return SessionService(ref.watch(secureStorageProvider));
});
