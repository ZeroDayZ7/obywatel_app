import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

class GlobalErrorInterceptor extends Interceptor {
  final AppLogger logger;

  GlobalErrorInterceptor({required this.logger});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Logujemy odpowiedź backendu do debugowania
    logger.i('💥 Dio error response: ${err.response?.data}');
    logger.i('💥 Status code: ${err.response?.statusCode}');
    logger.i('💥 Request path: ${err.requestOptions.path}');

    // Nie mapujemy błędu tutaj – zostanie zmapowany dopiero w AppException.fromDio
    handler.next(err);
  }
}
