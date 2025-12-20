import 'package:dio/dio.dart';
import 'package:obywatel_plus/app/config/services_config.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/global_error_interceptor.dart';

class PublicApiClient {
  final Dio _dio;
  final AppLogger _logger;

  PublicApiClient({required Dio dio, required AppLogger logger})
    : _dio = dio,
      _logger = logger {
    _configureDio();
  }

  void _configureDio() {
    _dio.options
      ..baseUrl = ServicesConfig.authBaseUrl
      ..connectTimeout = const Duration(seconds: 5)
      ..receiveTimeout = const Duration(seconds: 5)
      ..headers = {'Content-Type': 'application/json'};

    // Dodajemy globalny interceptor
    _dio.interceptors.add(GlobalErrorInterceptor());
  }

  Future<Response> get(String path) async {
    _logger.i('--> GET $path (public)');
    final resp = await _dio.get(path);
    _logger.i('<-- ${resp.statusCode} $path');
    return resp;
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    _logger.i('--> POST $path (public)');
    final resp = await _dio.post(
      path,
      data: data,
      options: Options(
        validateStatus: (status) => true,
      ), // akceptujemy wszystkie statusy
    );
    _logger.i('<-- ${resp.statusCode} $path');
    return resp;
  }
}
