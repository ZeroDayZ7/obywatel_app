import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/clients/no_auth_client.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/auth/domain/auth_response.dart';
import 'package:obywatel_plus/features/auth/domain/auth_user.dart';

class AuthService {
  final ApiClient _apiClient;
  final NoAuthApiClient _noAuthApiClient;
  final AppLogger _logger;

  AuthService({
    required ApiClient apiClient,
    required NoAuthApiClient noAuthApiClient,
    required AppLogger logger,
  }) : _apiClient = apiClient,
       _noAuthApiClient = noAuthApiClient,
       _logger = logger;

  /// Logowanie (Publiczne -> NoAuthApiClient)
  Future<AuthResponse> login(String email, List<int> passwordBytes) async {
    final response = await _noAuthApiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': passwordBytes},
    );

    return AuthResponse.fromMap(response.data as Map<String, dynamic>);
  }

  /// Weryfikacja 2FA (Publiczne -> NoAuthApiClient)
  Future<AuthResponse> verifyTwoFa(
    String email,
    List<int> codeBytes,
    String tempToken,
  ) async {
    final response = await _noAuthApiClient.post(
      ApiEndpoints.twoFaVerify,
      data: {'email': email, 'code': codeBytes, 'token': tempToken},
    );

    final data = response.data as Map<String, dynamic>;
    final setupToken = data[StorageKeys.setupToken]?.toString();

    if (setupToken == null) {
      throw Exception('errors.INVALID_2FA');
    }

    return AuthResponse.fromMap(data);
  }

  /// Weryfikacja urządzenia przy użyciu tymczasowego setupTokena (Publiczne z nagłówkiem jednorazowym)
  Future<AuthResponse> verifyDevice({
    required String setupToken,
    required String signature,
  }) async {
    final response = await _noAuthApiClient.post(
      ApiEndpoints.verifyDevice,
      data: {'signature': signature},
      options: Options(headers: {'Authorization': 'Bearer $setupToken'}),
    );

    return AuthResponse.fromMap(response.data as Map<String, dynamic>);
  }

  /// Pobranie aktualnego profilu (Zabezpieczone -> ApiClient)
  Future<AuthUser> fetchAuthMe() async {
    final response = await _apiClient.get(ApiEndpoints.authMe);
    return AuthUser.fromJson(response.data as Map<String, dynamic>);
  }

  /// Rejestracja zaufanego urządzenia (Działa na tymczasowym setupToken)
  Future<AuthResponse> registerTrustedDevice({
    required String fingerprint,
    required String publicKey,
    required String encryptedName,
    required String platform,
    required String signature,
    String? accessToken,
  }) async {
    final headers = <String, String>{};
    if (accessToken != null && accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    // ZMIANA: _noAuthApiClient zamiasat _apiClient, żeby Fresh nie mieszał w nagłówkach
    final response = await _noAuthApiClient.post(
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

    return AuthResponse.fromMap(response.data as Map<String, dynamic>);
  }

  /// Wylogowanie (Zabezpieczone -> ApiClient)
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
    noAuthApiClient: ref.watch(noAuthApiClientProvider),
    logger: ref.watch(appLoggerProvider),
  );
});
