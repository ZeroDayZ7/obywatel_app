import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/network/api_client.dart';
import 'package:obywatel_plus/app/config/storage_keys.dart';

class LoginService {
  final ApiClient apiClient;
  final SecureStorageService storage;
  final AppLogger logger;

  LoginService({
    required this.apiClient,
    required this.storage,
    required this.logger,
  });

  /// Zwraca token lub rzuca wyjątek
  Future<String> login(String email, String password) async {
    try {
      final response = await apiClient.post(
        '/auth/login',
        data: {'email': email.trim(), 'password': password},
      );

      final data = response.data;
      final token = data['token'] as String?;

      if (token == null) {
        throw Exception('Token not found in response');
      }

      // zapis tokenu w storage
      await storage.write(key: StorageKeys.accessToken, value: token);

      return token;
    } on DioException catch (e, st) {
      logger.e('DioException during login', error: e, stackTrace: st);
      rethrow;
    } catch (e, st) {
      logger.e('Unexpected error during login', error: e, stackTrace: st);
      rethrow;
    }
  }
}
