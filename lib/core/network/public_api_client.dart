import 'package:dio/dio.dart';
import 'package:obywatel_plus/app/config/services_config.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

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
  }

  Future<Response> get(String path) async {
    _logger.i('--> GET $path (public)');
    final resp = await _dio.get(path);
    _logger.i('<-- ${resp.statusCode} $path');
    return resp;
  }
}
