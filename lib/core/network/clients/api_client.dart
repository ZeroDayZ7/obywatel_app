import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';

class ApiClient {
  final Dio dio;
  final SecureStorageService storage;
  final AppLogger logger;

  ApiClient({required this.dio, required this.storage, required this.logger});

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParams,
    Options? options,
    Map<String, String>? headers,
  }) {
    final mergedOptions = options ?? Options();
    if (headers != null && headers.isNotEmpty) {
      final existing = mergedOptions.headers ?? <String, dynamic>{};
      mergedOptions.headers = {...existing, ...headers};
    }
    return dio.get<dynamic>(path, queryParameters: queryParams, options: mergedOptions);
  }

  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Options? options,
    Map<String, String>? headers,
  }) {
    final mergedOptions = options ?? Options();
    if (headers != null && headers.isNotEmpty) {
      final existing = mergedOptions.headers ?? <String, dynamic>{};
      mergedOptions.headers = {...existing, ...headers};
    }
    return dio.post<dynamic>(path, data: data, options: mergedOptions);
  }

  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    Options? options,
  }) => dio.patch<dynamic>(path, data: data, options: options);

  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    Options? options,
  }) => dio.put<dynamic>(path, data: data, options: options);

  Future<Response<dynamic>> delete(
    String path, {
    Object? data,
    Options? options,
  }) => dio.delete<dynamic>(path, data: data, options: options);

  Future<Response<dynamic>> upload(
    String path,
    FormData formData, {
    Options? options,
  }) => dio.post<dynamic>(
    path,
    data: formData,
    options:
        options ?? Options(headers: {'Content-Type': 'multipart/form-data'}),
  );
}
