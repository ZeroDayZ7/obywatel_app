// lib/core/errors/app_exception.dart
import 'package:dio/dio.dart';

enum ErrorType {
  business, // Walidacja, złe hasło
  system, // Brak internetu, 5xx, timeout
  critical, // Np. 401 token expired
}

class AppException implements Exception {
  final String messageKey;
  final ErrorType type;

  AppException({required this.messageKey, required this.type});

  // Klasyfikacja błędów Dio na nasze typy
  factory AppException.fromDio(Object error) {
    if (error is DioException) {
      // 1. Błędy sieciowe
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError) {
        return AppException(
          messageKey: 'errors.CONNECTION_ERROR',
          type: ErrorType.system,
        );
      }

      final statusCode = error.response?.statusCode ?? 0;
      final data = error.response?.data;

      // 2. Błędy serwera
      if (statusCode >= 500) {
        return AppException(
          messageKey: 'errors.SERVER_ERROR',
          type: ErrorType.system,
        );
      }

      // 3. Błędy biznesowe (400/422/404)
      if (statusCode >= 400 && statusCode < 500) {
        if (data is Map && data['code'] != null) {
          return AppException(
            messageKey: 'errors.${data['code']}',
            type: ErrorType.business,
          );
        }
        return AppException(
          messageKey: 'errors.UNKNOWN_BUSINESS',
          type: ErrorType.business,
        );
      }
    }

    // Fallback
    return AppException(
      messageKey: 'errors.UNKNOWN_ERROR',
      type: ErrorType.system,
    );
  }
}
