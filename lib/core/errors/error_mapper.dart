import 'package:dio/dio.dart';
import 'failure.dart';

class ErrorMapper {
  static Failure mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Przekroczono czas oczekiwania');

      case DioExceptionType.badResponse:
        final data = e.response?.data;
        final message = data is Map ? data['message'] : 'Błąd serwera';
        return ServerFailure(
          message ?? 'Błąd krytyczny',
          statusCode: e.response?.statusCode,
        );

      case DioExceptionType.cancel:
        return const UnknownFailure('Żądanie zostało anulowane');

      default:
        return const UnknownFailure();
    }
  }
}
