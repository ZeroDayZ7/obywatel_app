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
  /// Zwraca token JWT w przypadku sukcesu
  Future<String> login(String email, String password) async {
    logger.i('Starting login request for $email');

    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      logger.d('Login response status: ${response.statusCode}');
      logger.d('Response data: ${response.data}');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data != null && data['token'] != null) {
          final token = data['token'];
          logger.i('Login successful for user: $email');
          return token;
        } else {
          logger.w('Token not found in response for user: $email');
          throw Exception('Token not found in response');
        }
      } else {
        logger.w(
          'Login failed with status: ${response.statusCode}, message: ${response.statusMessage}',
        );
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e, st) {
      if (e.response != null) {
        logger.e('DioException during login request', error: e, stackTrace: st);
        logger.d('Response data: ${e.response?.data}');
        throw Exception('Login failed: ${e.response?.data}');
      } else {
        logger.e(
          'Network or unexpected Dio error during login',
          error: e,
          stackTrace: st,
        );
        throw Exception('Login failed: ${e.message}');
      }
    } catch (e, st) {
      logger.e('Unexpected error during login', error: e, stackTrace: st);
      rethrow;
    }
  }
}
