// features/auth/application/session_service.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';

class SessionService extends Notifier<AuthState> {
  late final SecureStorageService _storage;

  @override
  AuthState build() {
    _storage = ref.read(secureStorageProvider);
    _restoreSession();
    return AuthState.initial();
  }

  /// Asynchroniczna inicjalizacja przy starcie aplikacji
  Future<void> init() async {
    final token = await _storage.read(key: StorageKeys.accessToken);
    final userId = await _storage.read(key: StorageKeys.userId);

    if (token != null && token.isNotEmpty) {
      state = AuthState(isLoggedIn: true, userId: userId);
    }
  }

  // ===============================
  // SESSION RESTORE
  // ===============================

  Future<void> _restoreSession() async {
    final token = await _storage.read(key: StorageKeys.accessToken);
    final userId = await _storage.read(key: StorageKeys.userId);

    if (token != null && token.isNotEmpty) {
      state = AuthState(isLoggedIn: true, userId: userId);
    }
  }

  // ===============================
  // START SESSION
  // ===============================

  Future<void> startSession({
    required String accessToken,
    required String refreshToken,
    String? userId,
  }) async {
    await _storage.write(key: StorageKeys.accessToken, value: accessToken);
    await _storage.write(key: StorageKeys.refreshToken, value: refreshToken);

    if (userId != null) {
      await _storage.write(key: StorageKeys.userId, value: userId);
    }

    state = AuthState(isLoggedIn: true, userId: userId);
  }

  // ===============================
  // ACCESSORS
  // ===============================

  Future<String?> getAccessToken() =>
      _storage.read(key: StorageKeys.accessToken);

  Future<String?> getRefreshToken() =>
      _storage.read(key: StorageKeys.refreshToken);

  Future<String?> getUserId() => _storage.read(key: StorageKeys.userId);

  // ===============================
  // END SESSION
  // ===============================

  Future<void> endSession() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
    await _storage.delete(key: StorageKeys.userId);

    state = AuthState.initial();
  }
}

// Provider
final sessionServiceProvider = NotifierProvider<SessionService, AuthState>(
  SessionService.new,
);
