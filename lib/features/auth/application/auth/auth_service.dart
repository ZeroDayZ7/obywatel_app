import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_client.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/auth/domain/auth_response.dart';

class AuthService {
  final ApiClient _apiClient;
  final AppLogger _logger;

  AuthService({required ApiClient apiClient, required AppLogger logger})
    : _apiClient = apiClient,
      _logger = logger;

  /// Logowanie: zwraca AuthResponse (2FA lub success)
  /// 🔥 UWAGA: Usunięto try-catch. Błędy DioException lecą do AuthController.
  Future<AuthResponse> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );

    final data = response.data;

    // 2FA required
    if (data['2fa_required'] == true) {
      final token = data['two_fa_token']?.toString();
      if (token == null) {
        throw Exception('errors.INVALID_2FA_TOKEN');
      }
      return AuthResponse.twoFaRequired(twoFaToken: token);
    }

    // Successful login
    final accessToken = data['access_token']?.toString();
    final refreshToken = data['refresh_token']?.toString();
    final userId = data['user_id']?.toString();

    if (accessToken == null || refreshToken == null || userId == null) {
      throw Exception('errors.INVALID_LOGIN_RESPONSE');
    }

    return AuthResponse.success(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
    );
  }

  /// Weryfikacja 2FA
  Future<AuthResponse> verifyTwoFa(
    String email,
    String code,
    String tempToken,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.twoFaVerify,
      data: {'email': email, 'code': code, 'token': tempToken},
    );

    final data = response.data;

    final accessToken = data[StorageKeys.accessToken]?.toString();
    final refreshToken = data[StorageKeys.refreshToken]?.toString();
    final userId = data[StorageKeys.userId]?.toString();

    if (accessToken == null || refreshToken == null || userId == null) {
      throw Exception('errors.INVALID_2FA_RESPONSE');
    }

    return AuthResponse.success(
      accessToken: accessToken,
      refreshToken: refreshToken,
      userId: userId,
    );
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } catch (e) {
      _logger.w('Logout API failed, forcing local logout');
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    apiClient: ref.watch(apiClientProvider),
    logger: ref.watch(appLoggerProvider),
  );
});
