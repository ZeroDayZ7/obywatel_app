// lib/core/errors/app_exception.dart
import 'package:dio/dio.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

enum ErrorType { business, system, critical }

class AppException implements Exception {
  final String messageKey;
  final ErrorType type;

  AppException({required this.messageKey, required this.type});

  factory AppException.fromDio(Object error) {
    if (error is DioException) {
      // Błędy sieciowe
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError) {
        return AppException(
          messageKey: LocaleKeys.errors_CONNECTION_ERROR,
          type: ErrorType.system,
        );
      }

      final statusCode = error.response?.statusCode ?? 0;
      final data = error.response?.data;

      // Błędy serwera
      if (statusCode >= 500) {
        return AppException(
          messageKey: LocaleKeys.errors_SERVER_ERROR,
          type: ErrorType.system,
        );
      }

      // Błędy biznesowe (400/422/404)
      if (statusCode >= 400 && statusCode < 500) {
        if (data is Map && data['code'] != null) {
          return AppException(
            messageKey: 'errors.${data['code']}',
            type: ErrorType.business,
          );
        }
        return AppException(
          messageKey: LocaleKeys.errors_UNKNOWN_BUSINESS,
          type: ErrorType.business,
        );
      }
    }

    // Fallback
    return AppException(
      messageKey: LocaleKeys.errors_unexpected_error,
      type: ErrorType.system,
    );
  }
}
