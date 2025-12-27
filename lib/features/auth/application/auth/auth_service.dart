// features/auth/application/auth/auth_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_client.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';

class AuthResponse {
  final bool twoFaRequired;
  final String? twoFaToken; // Temp token
  final String? accessToken;
  final String? refreshToken;
  final String? userId;

  AuthResponse({
    this.twoFaRequired = false,
    this.twoFaToken,
    this.accessToken,
    this.refreshToken,
    this.userId,
  });
}

class AuthService {
  final ApiClient _apiClient;
  final AppLogger _logger;

  AuthService({required ApiClient apiClient, required AppLogger logger})
    : _apiClient = apiClient,
      _logger = logger;

  /// Logowanie: zwraca dane LUB rzuca wyjątek z komunikatem z backendu
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      final data = response.data;

      // Scenariusz 1: 2FA wymagane
      if (data['2fa_required'] == true) {
        return AuthResponse(
          twoFaRequired: true,
          twoFaToken: data['two_fa_token'],
        );
      }

      // Scenariusz 2: Sukces (zwraca tokeny bezpośrednio)
      return AuthResponse(
        accessToken: data[StorageKeys.accessToken],
        refreshToken: data[StorageKeys.refreshToken],
        userId: data['user_id']?.toString(), // Zabezpieczenie rzutowania
      );
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<AuthResponse> verifyTwoFa(
    String email,
    String code,
    String tempToken,
  ) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.twoFaVerify,
        data: {'email': email, 'code': code, 'token': tempToken},
      );
      final data = response.data;

      return AuthResponse(
        accessToken: data[StorageKeys.accessToken],
        refreshToken: data[StorageKeys.refreshToken],
        userId: data['user_id']?.toString(),
      );
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } catch (e) {
      _logger.w('Logout API failed, forcing local logout');
    }
  }

  /// Wyciąga wiadomość błędu z backendu (kluczowe dla naprawy buga)
  Exception _parseError(DioException e) {
    if (e.response?.data != null && e.response!.data is Map) {
      final data = e.response!.data as Map;
      // Backend zwraca: { "code": "INVALID_CREDENTIALS", "message": "..." }
      // Priorytet dla 'code' (do tłumaczeń), potem 'message'
      final msg = data['code'] ?? data['message'] ?? 'errors.UNKNOWN_ERROR';
      return Exception(msg);
    }
    return Exception('errors.CONNECTION_ERROR');
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    apiClient: ref.watch(apiClientProvider),
    logger: ref.watch(appLoggerProvider),
  );
});
