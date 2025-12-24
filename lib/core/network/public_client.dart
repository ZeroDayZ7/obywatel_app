import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

class PublicApiClient {
  final Dio dio;
  final AppLogger logger;

  PublicApiClient({required this.dio, required this.logger});

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) =>
      dio.get(path, queryParameters: queryParams);

  Future<Response> post(String path, {dynamic data}) =>
      dio.post(path, data: data);

  Future<Response> put(String path, {dynamic data}) =>
      dio.put(path, data: data);

  Future<Response> delete(String path, {Object? data}) =>
      dio.delete(path, data: data);
}
