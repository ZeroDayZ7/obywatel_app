import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

class PublicApiClient {
  final Dio dio;
  final AppLogger logger;

  PublicApiClient({required this.dio, required this.logger});

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParams,
  }) => dio.get<dynamic>(path, queryParameters: queryParams);

  Future<Response<dynamic>> post(String path, {dynamic data}) =>
      dio.post<dynamic>(path, data: data);

  Future<Response<dynamic>> put(String path, {dynamic data}) =>
      dio.put<dynamic>(path, data: data);

  Future<Response<dynamic>> delete(String path, {Object? data}) =>
      dio.delete<dynamic>(path, data: data);
}
