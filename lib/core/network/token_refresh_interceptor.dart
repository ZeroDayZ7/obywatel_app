import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';

class TokenRefreshInterceptor extends QueuedInterceptor {
  final Dio _dio;
  final SecureStorageService _storage;
  final AppLogger _logger;

  TokenRefreshInterceptor(this._dio, this._storage, this._logger);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        err.requestOptions.path != ApiEndpoints.refreshToken) {
      _logger.i('🔒 Wykryto 401. Próba odświeżenia tokena...');

      try {
        final refreshToken = await _storage.read(key: StorageKeys.refreshToken);
        if (refreshToken == null) {
          return handler.next(err);
        }

        // Odświeżenie tokena
        final response = await _dio.post(
          ApiEndpoints.refreshToken,
          data: {'refresh_token': refreshToken},
        );

        if (response.statusCode == 200) {
          final newAccessToken = response.data[StorageKeys.accessToken];
          final newRefreshToken = response.data[StorageKeys.refreshToken];

          await _storage.write(
            key: StorageKeys.accessToken,
            value: newAccessToken,
          );
          if (newRefreshToken != null) {
            await _storage.write(
              key: StorageKeys.refreshToken,
              value: newRefreshToken,
            );
          }

          _logger.i('🔓 Token odświeżony. Ponawiam zapytanie.');

          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newAccessToken';

          final retryResponse = await _dio.fetch(options);
          return handler.resolve(retryResponse);
        }
      } catch (e) {
        _logger.e('❌ Błąd odświeżania tokena', error: e);
        // Tutaj możesz triggerować globalne wylogowanie
      }
    }

    return handler.next(err);
  }
}
