import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

class LoggingInterceptor extends Interceptor {
  final AppLogger logger;

  LoggingInterceptor({required this.logger});

  // Lista pól do maskowania
  static const _sensitiveKeys = {
    'password',
    'password_confirmation',
    'access_token',
    'refresh_token',
    'token',
    'pin',
    'pesel',
    'email',
    'apiFingerprint',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final maskedData = _maskSensitiveData(options.data);
    logger.i('➡️ ${options.method} ${options.uri}');
    if (maskedData != null) {
      logger.i('📦 Body: $maskedData');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final maskedResponse = _maskSensitiveData(response.data);
    logger.i('⬅️ ${response.statusCode} ${response.requestOptions.uri}');
    if (maskedResponse != null) {
      logger.i('📥 Data: $maskedResponse');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e(
      '❌ ${err.response?.statusCode ?? "NO_CODE"} ${err.requestOptions.uri}',
    );
    if (err.response?.data != null) {
      final maskedError = _maskSensitiveData(err.response?.data);
      logger.e('💥 Error Details: $maskedError');
    }
    handler.next(err);
  }

  /// Rekurencyjne maskowanie danych
  dynamic _maskSensitiveData(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data.map((key, value) {
        if (_sensitiveKeys.contains(key.toLowerCase())) {
          return MapEntry(key, '********');
        }
        return MapEntry(key, _maskSensitiveData(value));
      });
    } else if (data is List) {
      return data.map(_maskSensitiveData).toList();
    }
    return data;
  }
}
