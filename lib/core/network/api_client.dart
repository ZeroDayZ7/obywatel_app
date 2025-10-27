import 'package:dio/dio.dart';
import '../storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

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
       _logger = logger;

  /// GET
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      final token = await _storage.read(key: 'accessToken');
      final res = await _dio.get(
        path,
        queryParameters: queryParams,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      return res;
    } catch (e, st) {
      _logger.e('GET $path failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// POST
  Future<Response> post(String path, {dynamic data}) async {
    try {
      final token = await _storage.read(key: 'accessToken');
      final res = await _dio.post(
        path,
        data: data,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      return res;
    } catch (e, st) {
      _logger.e('POST $path failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// PUT
  Future<Response> put(String path, {dynamic data}) async {
    try {
      final token = await _storage.read(key: 'accessToken');
      final res = await _dio.put(
        path,
        data: data,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      return res;
    } catch (e, st) {
      _logger.e('PUT $path failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// DELETE
  Future<Response> delete(String path) async {
    try {
      final token = await _storage.read(key: 'accessToken');
      final res = await _dio.delete(
        path,
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );
      return res;
    } catch (e, st) {
      _logger.e('DELETE $path failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}
