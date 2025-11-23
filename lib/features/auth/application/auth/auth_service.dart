// features/auth/application/auth_service.dart

import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/api_client.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/auth/application/auth/session_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginResult {
  final bool success;
  final String? error;
  const LoginResult({required this.success, this.error});
}

class AuthService {
  final ApiClient _apiClient;
  final AppLogger _logger;
  final SessionService _session;

  AuthService({
    required ApiClient apiClient,
    required AppLogger logger,
    required SessionService session,
  }) : _apiClient = apiClient,
       _logger = logger,
       _session = session;

  // ============================
  // LOGIN
  // ============================
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
      final userId = response.data[StorageKeys.userId] as String?;

      if (accessToken == null || refreshToken == null) {
        return const LoginResult(success: false, error: 'Missing tokens');
      }

      await _session.startSession(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: userId,
      );

      return const LoginResult(success: true);
    } catch (e, st) {
      _logger.e('Login failed', error: e, stackTrace: st);
      return LoginResult(success: false, error: e.toString());
    }
  }

  // ============================
  // LOGOUT
  // ============================
  Future<void> logout() async {
    try {
      final refreshToken = await _session.getRefreshToken();

      await _apiClient.post(
        ApiEndpoints.logout,
        data: {StorageKeys.refreshToken: refreshToken},
      );
    } catch (e, st) {
      _logger.w('Logout request failed', error: e, stackTrace: st);
    }

    await _session.endSession();
  }

  // ============================
  // TOKEN VALIDATION (simple)
  // ============================
  Future<bool> validateToken() async {
    try {
      final token = await _session.getAccessToken();
      if (token == null || token.isEmpty) return false;
      return true;
    } catch (e, st) {
      _logger.e('Token validation failed', error: e, stackTrace: st);
      return false;
    }
  }
}

// Provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    apiClient: ref.watch(apiClientProvider),
    logger: ref.watch(appLoggerProvider),
    session: ref.watch(sessionServiceProvider.notifier),
  );
});
