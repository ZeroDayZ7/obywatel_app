import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/core_providers.dart'
    show secureStorageProvider;
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';

class SessionService {
  final SecureStorageService _storage;
  final Ref _ref;

  SessionService(this._ref, this._storage);

  // ===============================
  // GETTERY
  // ===============================

  Future<String?> getAccessToken() =>
      _storage.read(key: StorageKeys.accessToken);

  Future<String?> getRefreshToken() =>
      _storage.read(key: StorageKeys.refreshToken);

  Future<String?> getUserId() => _storage.read(key: StorageKeys.userId);

  // ===============================
  // ZAPIS SESJI
  // ===============================

  Future<void> startSession({
    required String accessToken,
    required String refreshToken,
    String? userId,
  }) async {
    await _storage.write(key: StorageKeys.accessToken, value: accessToken);
    await _storage.write(key: StorageKeys.refreshToken, value: refreshToken);
    if (userId != null)
      await _storage.write(key: StorageKeys.userId, value: userId);

    // aktualizacja stanu logowania w Riverpod
    _ref.read(isLoggedInProvider.notifier).state = true;
  }

  Future<void> saveSession({
    required String accessToken,
    required String refreshToken,
    String? userId,
  }) => startSession(
    accessToken: accessToken,
    refreshToken: refreshToken,
    userId: userId,
  );

  // ===============================
  // WALIDACJA SESJI
  // ===============================

  Future<bool> hasRefreshToken() async {
    final token = await getRefreshToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> restoreSession() async {
    final token = await getAccessToken();
    _ref.read(isLoggedInProvider.notifier).state =
        token != null && token.isNotEmpty;
  }

  // ===============================
  // CZYSZCZENIE SESJI
  // ===============================

  Future<void> endSession() => clearSession();

  Future<void> clearSession() async {

    await authService.logout();
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
    await _storage.delete(key: StorageKeys.userId);

    _ref.read(isLoggedInProvider.notifier).state = false;
  }
}

/// Provider Riverpoda dla SessionService
final sessionServiceProvider = Provider<SessionService>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return SessionService(ref, storage);
});
