// features/auth/application/auth_service.dart

import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/api_client.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
// auth_service_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/core_providers.dart' show appLoggerProvider;

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
      // Wyślij request do backendu
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      // Log całego response JSON
      _logger.i('Login response: ${response.data}');

      // Pobranie tokenów i userId
      final accessToken = response.data[StorageKeys.accessToken] as String?;
      final refreshToken = response.data[StorageKeys.refreshToken] as String?;
      final userId = response.data[StorageKeys.userId] as String?;

      if (accessToken == null || refreshToken == null || userId == null) {
        return const LoginResult(
          success: false,
          error: 'Brak tokenów w odpowiedzi serwera.',
        );
      }

      // Rozpocznij sesję
      await _session.startSession(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: userId,
      );

      return const LoginResult(success: true);
    } catch (e, st) {
      _logger.e('Login failed', error: e, stackTrace: st);

      // Domyślny komunikat błędu
      String errorMessage = 'Wystąpił błąd. Spróbuj ponownie.';

      // Jeśli Dio zwrócił odpowiedź z backendu, użyj jej komunikatu
      if (e is DioException && e.response != null) {
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'];
        }
        // opcjonalnie możesz też logować cały JSON błędu
        _logger.i('Backend error response: $data');
      }

      return LoginResult(success: false, error: errorMessage);
    }
  }

  // ============================
  // LOGOUT
  // ============================
  Future<void> logout() async {
    final refreshToken = await _session.getRefreshToken();

    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        final response = await _apiClient.post(
          ApiEndpoints.logout,
          data: {StorageKeys.refreshToken: refreshToken},
        );
        _logger.i('Logout response: ${response.data}');
      }
    } on DioException catch (e, st) {
      // logujemy błąd, ale nie przerywamy procesu
      _logger.w('Logout request failed', error: e, stackTrace: st);

      if (e.response != null) {
        _logger.w('Logout response data', error: e.response!.data);
      }
    } catch (e, st) {
      _logger.e('Unexpected error during logout', error: e, stackTrace: st);
    } finally {
      // kończymy sesję lokalnie
      await _session.endSession();
      _logger.w('kończymy sesję lokalnie');
    }
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
