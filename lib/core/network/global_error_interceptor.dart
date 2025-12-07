import 'dart:io';
import 'package:dio/dio.dart';

class GlobalErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message = 'Wystąpił błąd. Spróbuj ponownie.';

    // brak internetu / DNS / airplane mode
    if (err.type == DioExceptionType.connectionError || err.error is SocketException) {
      message = 'Brak połączenia z serwerem.';
    }
    // timeout
    else if (err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.connectionTimeout) {
      message = 'Przekroczono czas oczekiwania.';
    }
    // serwer nie odpowiada lub padł — brak response
    else if (err.response == null) {
      message = 'Błąd serwera. Spróbuj ponownie.';
    }
    // backend zwrócił message
    else {
      message = err.response?.data['message'] ?? message;
    }

    // Tworzymy NOWY wyjątek z naszym message
    final modifiedError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: message,
      stackTrace: err.stackTrace,
    );

    return handler.next(modifiedError);
  }
}
