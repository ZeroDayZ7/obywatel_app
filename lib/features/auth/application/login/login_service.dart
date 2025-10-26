import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/features/auth/data/remote/auth_api.dart';

class LoginService {
  final AuthApi authApi;
  final SecureStorageService storage;
  final AppLogger logger;

  LoginService({
    required this.authApi,
    required this.storage,
    required this.logger,
  });

  /// Zwraca token lub rzuca wyjątek
  Future<String> login(String email, String password) async {
    try {
      final response = await authApi.login(email.trim(), password);
      final token = response['token'] as String;

      // zapis tokenu
      await storage.write(key: 'accessToken', value: token);

      return token;
    } on DioException catch (e) {
      logger.e('DioException during login', error: e, stackTrace: e.stackTrace);
      rethrow;
    } catch (e, st) {
      logger.e('Unexpected error during login', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Określa, dokąd przejść po zalogowaniu
  Future<String> determineNextRoute() async {
    final pin = await storage.read(key: 'user_pin');
    final hasLocalLock = pin != null && pin.isNotEmpty;
    final biometricEnabled = await storage.read(key: 'biometric') == 'true';

    if (!hasLocalLock) return '/securitySetup';
    if (biometricEnabled) return '/pin';
    return '/home';
  }
}
