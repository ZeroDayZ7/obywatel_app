import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

class GlobalErrorInterceptor extends Interceptor {
  final AppLogger logger;

  GlobalErrorInterceptor({required this.logger});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // NIE robimy tutaj UI rzeczy ani resetów sesji.
    // Interceptor tylko dokumentuje fakt wystąpienia błędu.

    if (err.type == DioExceptionType.connectionTimeout) {
      logger.e(
        '🌐 Network Timeout: Check your internet connection',
        module: 'NETWORK',
      );
    }

    // Przekazujemy błąd do konkretnego Controlera, który wywołał request
    handler.next(err);
  }
}
