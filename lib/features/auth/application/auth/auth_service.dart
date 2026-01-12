import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
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
  Future<AuthResponse> login(String email, List<int> passwordBytes) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': passwordBytes},
    );

    return AuthResponse.fromMap(response.data);
  }

  /// Weryfikacja 2FA
  Future<AuthResponse> verifyTwoFa(
    String email,
    List<int> codeBytes,
    String tempToken,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.twoFaVerify,
      data: {'email': email, 'code': codeBytes, 'token': tempToken},
    );

    final data = response.data;

    final setupToken = data[StorageKeys.setupToken]?.toString();

    if (setupToken == null) {
      throw Exception('errors.INVALID_2FA');
    }

    return AuthResponse.fromMap(response.data);
  }

  Future<AuthResponse> registerTrustedDevice({
    required String fingerprint,
    required String publicKey,
    required String encryptedName,
    required String platform,
    required String signature,
    String? accessToken,
  }) async {
    final headers = <String, String>{};
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    final response = await _apiClient.post(
      ApiEndpoints.registerDevice,
      data: {
        'fingerprint': fingerprint,
        'public_key': publicKey,
        'encrypted_name': encryptedName,
        'platform': platform,
        'signature': signature,
      },
      options: Options(headers: headers),
    );

    return AuthResponse.fromJson(response.data);
  }

  /// Logout
  Future<void> logout(String? refreshToken) async {
    try {
      await _apiClient.post(
        ApiEndpoints.logout,
        data: {StorageKeys.refreshToken: refreshToken},
      );
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
