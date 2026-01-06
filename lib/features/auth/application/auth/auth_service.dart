import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/auth/domain/auth_models.dart';
import 'package:obywatel_plus/features/auth/domain/auth_response.dart';

class AuthService {
  final ApiClient _apiClient;
  final AppLogger _logger;

  AuthService({required ApiClient apiClient, required AppLogger logger})
    : _apiClient = apiClient,
      _logger = logger;

  /// Logowanie: zwraca AuthResponse (2FA lub success)
  /// Logowanie: zwraca AuthResponse (2FARequired lub PreTrust/FullSuccess)
  Future<AuthResponse> login(String email, List<int> passwordBytes) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': passwordBytes},
    );

    final data = response.data;

    // 1. Obsługa wymaganego 2FA
    if (data['2fa_required'] == true) {
      return AuthResponse.twoFaRequired(
        twoFaToken: data['two_fa_token'].toString(),
      );
    }

    // 2. Jeśli nie 2FA, mapujemy na wynik weryfikacji urządzenia
    return _mapToAuthResponse(data);
  }

  /// Pomocnicza metoda do mapowania danych sukcesu
  AuthResponse _mapToAuthResponse(Map<String, dynamic> data) {
    final isTrusted = data['is_trusted'] as bool? ?? false;
    final accessToken = data['access_token'].toString();

    if (!isTrusted) {
      // Urządzenie niezweryfikowane - zwracamy PreTrust (z challenge)
      return AuthResponse.preTrust(
        accessToken: accessToken,
        challenge: data['challenge']?.toString() ?? '',
        isTrusted: false,
      );
    }

    // Pełny sukces - urządzenie jest już zaufane
    return AuthResponse.fullSuccess(
      accessToken: accessToken,
      refreshToken: data['refresh_token'].toString(),
      user: UserProfile.fromJson(data['user'] as Map<String, dynamic>),
      rbac: RbacData.fromJson(data['rbac'] as Map<String, dynamic>),
    );
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

    final accessToken = data[StorageKeys.accessToken]?.toString();

    if (accessToken == null) {
      throw Exception('errors.INVALID_2FA');
    }

    return _mapToAuthResponse(data);
  }

  Future<String?> registerTrustedDevice({
    required String fingerprint,
    required String publicKey,
    required String encryptedName,
    required String platform,
    required String signature,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.registerDevice,
      data: {
        'fingerprint': fingerprint,
        'public_key': publicKey,
        'encrypted_name': encryptedName,
        'platform': platform,
        'signature': signature,
      },
    );

    _logger.i('Device registration successful for: $fingerprint');

    // Wyciągamy nowy token z odpowiedzi (zakładając, że backend go wyśle)
    return response.data['access_token']?.toString();
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
