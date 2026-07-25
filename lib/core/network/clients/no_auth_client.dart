import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

class NoAuthApiClient {
  final Dio dio;
  final AppLogger logger;

  NoAuthApiClient({required this.dio, required this.logger});

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParams,
    Options? options,
  }) => dio.get<dynamic>(path, queryParameters: queryParams, options: options);

  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Options? options,
  }) => dio.post<dynamic>(path, data: data, options: options);
}
