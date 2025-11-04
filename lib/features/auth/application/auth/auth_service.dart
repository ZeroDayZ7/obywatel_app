// lib/features/auth/data/auth_service.dart
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/api_client.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';

class LoginResult {
  final bool success;
  final String? error;

  const LoginResult({required this.success, this.error});
}

class AuthService {
  final ApiClient _apiClient;
  final SecureStorageService _storage;
  final AppLogger _logger;

  AuthService({
    required ApiClient apiClient,
    required SecureStorageService storage,
    required AppLogger logger,
  }) : _apiClient = apiClient,
       _storage = storage,
       _logger = logger;

  /// Logowanie użytkownika
  Future<LoginResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      _logger.i('Login response: ${response.data}');

      final accessToken = response.data[StorageKeys.accessToken] as String?;
      final refreshToken = response.data[StorageKeys.refreshToken] as String?;

      if (accessToken != null && refreshToken != null) {
        await _storage.write(key: StorageKeys.accessToken, value: accessToken);
        await _storage.write(
          key: StorageKeys.refreshToken,
          value: refreshToken,
        );

        _logger.i('Login successful');
        return const LoginResult(success: true);
      }

      return const LoginResult(
        success: false,
        error: 'Tokens missing in response',
      );
    } catch (e, st) {
      _logger.e('Login failed', error: e, stackTrace: st);
      return LoginResult(success: false, error: e.toString());
    }
  }

  /// Wylogowanie użytkownika
  Future<void> logout() async {
    try {
      final refreshToken = await _storage.read(key: StorageKeys.refreshToken);

      await _apiClient.post(
        ApiEndpoints.logout,
        data: {StorageKeys.refreshToken: refreshToken},
      );
    } catch (e, st) {
      _logger.w('Logout request failed', error: e, stackTrace: st);
    }

    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
    _logger.i('User logged out');
  }

  /// Walidacja tokena przy starcie aplikacji
  Future<bool> validateToken() async {
    try {
      final token = await _storage.read(key: StorageKeys.accessToken);
      if (token == null || token.isEmpty) return false;

      final response = await _apiClient.get(ApiEndpoints.userProfile);

      if (response.statusCode == 200) {
        _logger.i('Token valid');
        return true;
      }

      // jeśli status 401, można spróbować refresh token
      return await _tryRefreshToken();
    } catch (e, st) {
      _logger.e('Token validation failed', error: e, stackTrace: st);
      return false;
    }
  }

  /// Próba odświeżenia tokena
  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refreshToken');
      if (refreshToken == null) return false;

      final response = await _apiClient.post(
        '${ApiEndpoints.login}/refresh',
        data: {'refreshToken': refreshToken},
      );

      final newToken = response.data['accessToken'] as String?;
      if (newToken != null) {
        await _storage.write(key: 'accessToken', value: newToken);
        _logger.i('Token refreshed successfully');
        return true;
      }
      return false;
    } catch (e, st) {
      _logger.e('Token refresh failed', error: e, stackTrace: st);
      return false;
    }
  }
}
