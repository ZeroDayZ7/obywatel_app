import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

class GlobalErrorInterceptor extends Interceptor {
  final AppLogger logger;

  GlobalErrorInterceptor({required this.logger});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Logujemy tylko ogólne informacje.
    // Szczegóły (zmaskowane!) wypisze nam LoggingInterceptor.
    logger.e('💥 Global Error Handler: [${err.type}] ${err.message}');

    // Tutaj możesz dodać logikę analityczną (np. wysyłkę do Sentry/Crashlytics)
    // ale bez wysyłania wrażliwych danych z err.response?.data

    handler.next(err);
  }
}
