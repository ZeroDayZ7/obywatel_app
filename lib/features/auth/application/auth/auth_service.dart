// features/auth/application/auth_service.dart

import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/api_client.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/core_providers.dart' show appLoggerProvider;

class LoginResult {
  final bool success;
  final String? error;
  final bool twoFaRequired;
  final String? twoFaToken;
  final String? accessToken;
  final String? refreshToken;

  const LoginResult({
    required this.success,
    this.error,
    this.twoFaRequired = false,
    this.twoFaToken,
    this.accessToken,
    this.refreshToken,
  });
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
    // Wysyłamy request – jeśli coś pójdzie nie tak, Dio rzuci wyjątek
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    _logger.i('Login response: ${response.data}');

    // Obsługa 2FA
    if (response.data['2fa_required'] == true) {
      return LoginResult(
        success: true,
        twoFaRequired: true,
        twoFaToken: response.data['two_fa_token'] as String?,
      );
    }

    // Pobranie tokenów i userId
    final accessToken = response.data[StorageKeys.accessToken] as String?;
    final refreshToken = response.data[StorageKeys.refreshToken] as String?;
    final userId = response.data[StorageKeys.userId] as String?;

    if (accessToken == null || refreshToken == null || userId == null) {
      // Rzucamy wyjątek, jeśli odpowiedź nie zawiera tokenów
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        error: "Invalid response format: missing tokens",
      );
    }

    await _session.startSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
    );

    return const LoginResult(success: true);
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
  // TOKEN VALIDATION
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

  // ============================
  // Verify Two Fa
  // ============================
  Future<LoginResult> verifyTwoFa({
    required String email,
    required String code,
    required String token,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.twoFaVerify,
        data: {'email': email, 'code': code, 'token': token},
      );

      final accessToken = response.data[StorageKeys.accessToken] as String?;
      final refreshToken = response.data[StorageKeys.refreshToken] as String?;
      final userId = response.data[StorageKeys.userId] as String?;

      if (accessToken == null || refreshToken == null || userId == null) {
        return const LoginResult(
          success: false,
          error: 'Brak tokenów w odpowiedzi serwera.',
        );
      }

      await _session.startSession(
        accessToken: accessToken,
        refreshToken: refreshToken,
        userId: userId,
      );

      return LoginResult(
        success: true,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    } catch (e, st) {
      _logger.e('2FA verification failed', error: e, stackTrace: st);

      String errorMessage = 'Wystąpił błąd. Spróbuj ponownie.';
      if (e is DioException && e.response != null) {
        final data = e.response!.data;
        if (data is Map && data['code'] != null) {
          errorMessage = 'errors.${data['code']}';
        }
      }
      return LoginResult(success: false, error: errorMessage);
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
