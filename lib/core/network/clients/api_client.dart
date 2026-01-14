import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';

class ApiClient {
  final Dio dio;
  final SecureStorageService storage;
  final AppLogger logger;

  ApiClient({required this.dio, required this.storage, required this.logger});

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParams,
    Options? options,
  }) => dio.get(path, queryParameters: queryParams, options: options);

  Future<Response> post(
    String path, {
    dynamic data,
    Options? options,
  }) => dio.post(path, data: data, options: options);

  Future<Response> put(String path, {dynamic data, Options? options}) =>
      dio.put(path, data: data, options: options);

  Future<Response> delete(String path, {Object? data, Options? options}) =>
      dio.delete(path, data: data, options: options);

  Future<Response> upload(String path, FormData formData, {Options? options}) =>
      dio.post(
        path,
        data: formData,
        options:
            options ??
            Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
}
