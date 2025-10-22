import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

class AuthApi {
  final String baseUrl;
  final Dio _dio;
  final AppLogger logger = AppLogger();

  AuthApi({required this.baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          headers: {'Content-Type': 'application/json'},
        ),
      ) {
    logger.i('AuthApi initialized with baseUrl: $baseUrl');
  }

  /// Logowanie użytkownika
  /// Zwraca mapę { 'token': String, '2fa_required': bool }
  Future<Map<String, dynamic>> login(String email, String password) async {
    logger.i('Starting login request for $email');

    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      logger.d('Login response status: ${response.statusCode}');
      logger.d('Response data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final token = data['token'];
        final twoFaRequired = data['2fa_required'] ?? false;

        if (token == null) {
          logger.w('Token not found in response for user: $email');
          throw Exception('Token not found in response');
        }

        return {'token': token, '2fa_required': twoFaRequired};
      } else {
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e, st) {
      logger.e('DioException during login request', error: e, stackTrace: st);
      throw Exception('Login failed: ${e.response?.data ?? e.message}');
    } catch (e, st) {
      logger.e('Unexpected error during login', error: e, stackTrace: st);
      rethrow;
    }
  }
}
