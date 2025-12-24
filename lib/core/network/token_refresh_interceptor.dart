import 'package:dio/dio.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/app/config/services_config.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';

class TokenRefreshInterceptor extends QueuedInterceptor {
  final Dio _dio;
  final SecureStorageService _storage;
  final AppLogger _logger;
  final SessionService _sessionService;

  TokenRefreshInterceptor(
    this._dio,
    this._storage,
    this._logger,
    this._sessionService,
  );

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 1️⃣ Warunek refresh
    if (err.response?.statusCode != 401 ||
        err.requestOptions.path == ApiEndpoints.login ||
        err.requestOptions.path == ApiEndpoints.register ||
        err.requestOptions.path == ApiEndpoints.refreshToken ||
        err.requestOptions.path == ApiEndpoints.twoFaVerify ||
        err.requestOptions.path == ApiEndpoints.twoFaResend ||
        err.requestOptions.path == ApiEndpoints.logout) {
      return handler.next(err);
    }
    _logger.i('🔒 401 detected → trying refresh token');

    try {
      final refreshToken = await _storage.read(key: StorageKeys.refreshToken);
      if (refreshToken == null) {
        throw Exception('No refresh token');
      }

      // 2️⃣ 🔥 OSOBNY DIO TYLKO DO REFRESH
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: ServicesConfig.authBaseUrl,
          connectTimeout: Duration(seconds: apiConstants.connectTimeoutSeconds),
          receiveTimeout: Duration(seconds: apiConstants.receiveTimeoutSeconds),
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // (opcjonalnie) minimalne logowanie
      // refreshDio.interceptors.add(LogInterceptor(requestBody: true));

      // 3️⃣ Request refresh
      final response = await refreshDio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode != 200) {
        throw Exception('Refresh failed with ${response.statusCode}');
      }

      // 4️⃣ Zapis nowych tokenów
      final newAccessToken = response.data[StorageKeys.accessToken];
      final newRefreshToken = response.data[StorageKeys.refreshToken];

      await _storage.write(key: StorageKeys.accessToken, value: newAccessToken);

      if (newRefreshToken != null) {
        await _storage.write(
          key: StorageKeys.refreshToken,
          value: newRefreshToken,
        );
      }

      _logger.i('🔓 Token refreshed → retrying original request');

      // 5️⃣ Ponów oryginalne zapytanie
      final requestOptions = err.requestOptions;
      requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      final retryResponse = await _dio.fetch(requestOptions);
      return handler.resolve(retryResponse);
    } catch (e, stack) {
      _logger.e('❌ Refresh failed → logout', error: e, stackTrace: stack);

      // 6️⃣ TU: global logout
      await _sessionService.endSession();

      return handler.next(err);
    }
  }
}
