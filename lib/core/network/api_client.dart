import 'package:dio/dio.dart';
import 'package:obywatel_plus/app/config/services_config.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/core/network/token_refresh_interceptor.dart';
import 'package:obywatel_plus/core/network/global_error_interceptor.dart';

class ApiClient {
  final Dio _dio;
  final SecureStorageService _storage;
  final AppLogger _logger;

  ApiClient({
    required Dio dio,
    required SecureStorageService storage,
    required AppLogger logger,
  }) : _dio = dio,
       _storage = storage,
       _logger = logger {
    _configureDio();
  }

  void _configureDio() {
    _dio.options
      ..baseUrl = ServicesConfig.authBaseUrl
      ..connectTimeout = Duration(seconds: apiConstants.connectTimeoutSeconds)
      ..receiveTimeout = Duration(seconds: apiConstants.receiveTimeoutSeconds)
      ..headers = {'Content-Type': 'application/json'};

    _dio.interceptors.addAll([
      _createAuthInterceptor(),
      _createLoggingInterceptor(),
      TokenRefreshInterceptor(_dio, _storage, _logger),
      GlobalErrorInterceptor(),
    ]);
  }

  Interceptor _createAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: StorageKeys.accessToken);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    );
  }

  Interceptor _createLoggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.i('🚀 REQUEST[${options.method}] => PATH: ${options.path}');
        if (options.data != null) _logger.i('Body: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.i(
          '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
        );
        return handler.next(response);
      },
      onError: (err, handler) {
        _logger.e(
          '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
        );
        return handler.next(err);
      },
    );
  }

  // --- Metody HTTP ---
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) =>
      _dio.get(path, queryParameters: queryParams);

  Future<Response> post(String path, {dynamic data}) =>
      _dio.post(path, data: data);

  Future<Response> put(String path, {dynamic data}) =>
      _dio.put(path, data: data);

  Future<Response> delete(String path, {Object? data}) =>
      _dio.delete(path, data: data);

  Future<Response> upload(String path, FormData formData) => _dio.post(
    path,
    data: formData,
    options: Options(headers: {'Content-Type': 'multipart/form-data'}),
  );
}
