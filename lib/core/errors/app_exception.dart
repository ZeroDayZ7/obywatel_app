// lib/core/errors/app_exception.dart
import 'package:dio/dio.dart';

enum ErrorType { business, system, critical }

class AppException implements Exception {
  final String messageKey; // np. 'login_2fa_invalid_code'
  final ErrorType type;

  AppException({required this.messageKey, required this.type});

  factory AppException.fromDio(Object error) {
    if (error is DioException) {
      // Błędy sieciowe
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError) {
        return AppException(
          messageKey: 'errors_CONNECTION_ERROR',
          type: ErrorType.system,
        );
      }

      final statusCode = error.response?.statusCode ?? 0;
      final data = error.response?.data;

      // Błędy serwera
      if (statusCode >= 500) {
        return AppException(
          messageKey: 'errors_SERVER_ERROR',
          type: ErrorType.system,
        );
      }

      // Błędy biznesowe (400/422/404)
      if (statusCode >= 400 && statusCode < 500) {
        if (data is Map && data['code'] != null) {
          // Tutaj backend zwraca dokładny kod, który odpowiada kluczowi w LocaleKeys
          return AppException(
            messageKey: data['code'], // np. 'login_2fa_invalid_code'
            type: ErrorType.business,
          );
        }
        return AppException(
          messageKey: 'errors_UNKNOWN_BUSINESS',
          type: ErrorType.business,
        );
      }
    }

    // Fallback
    return AppException(
      messageKey: 'errors_UNKNOWN_ERROR',
      type: ErrorType.system,
    );
  }
}
