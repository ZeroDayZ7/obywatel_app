import 'package:dio/dio.dart';
import 'package:obywatel_plus/app/config/storage_keys.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import '../storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/app/config/env.dart';

class ApiClient {
  final Dio _dio;
  final Dio _tokenRefreshDio;
  final SecureStorageService _storage;
  final AppLogger _logger;

  ApiClient({
    required Dio dio,
    required Dio tokenRefreshDio,
    required SecureStorageService storage,
    required AppLogger logger,
  }) : _dio = dio,
       _tokenRefreshDio = tokenRefreshDio,
       _storage = storage,
       _logger = logger {
    _configureDio();
  }

  void _configureDio() {
    _dio.options
      ..baseUrl = apiConstants.baseUrl
      ..connectTimeout = Duration(seconds: apiConstants.connectTimeoutSeconds)
      ..receiveTimeout = Duration(seconds: apiConstants.receiveTimeoutSeconds)
      ..headers = {'Content-Type': 'application/json'};

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: StorageKeys.accessToken);
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          _logger.i('--> ${options.method} ${options.path}');
          return handler.next(options);
        },
        onError: (error, handler) {
          _logger.e(
            '<-- ${error.requestOptions.method} ${error.requestOptions.path} FAILED',
            error: error.error,
            stackTrace: error.stackTrace,
          );
          return handler.next(error);
        },
        onResponse: (response, handler) {
          _logger.i(
            '<-- ${response.statusCode} ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
      ),
    );

    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 &&
              !error.requestOptions.path.contains('/auth/refresh')) {
            _logger.w('Token wygasł. Próba odświeżenia...');

            try {
              final newToken = await _refreshToken();

              if (newToken != null) {
                await _storage.write(key: StorageKeys.accessToken, value: newToken);

                final options = error.requestOptions;
                options.headers['Authorization'] = 'Bearer $newToken';

                final retryResponse = await _dio.fetch(options);
                return handler.resolve(retryResponse);
              }
            } catch (e) {
              _logger.e('Nie udało się odświeżyć tokena.', error: e);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refreshToken');
      if (refreshToken == null) return null;

      final response = await _tokenRefreshDio.post(ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data['accessToken'] as String?;
      }
      return null;
    } catch (e) {
      _logger.e('Błąd podczas _refreshToken', error: e);
      return null;
    }
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParams,
  }) async => await _dio.get(path, queryParameters: queryParams);

  Future<Response> post(String path, {dynamic data}) async =>
      await _dio.post(path, data: data);

  Future<Response> put(String path, {dynamic data}) async =>
      await _dio.put(path, data: data);

  Future<void> delete(String path, {Object? data}) async =>
      await _dio.delete(path, data: data);

  Future<Response> upload(String path, FormData formData) async =>
      await _dio.post(
        path,
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
}
