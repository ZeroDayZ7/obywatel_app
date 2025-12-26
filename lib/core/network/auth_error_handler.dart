import 'package:dio/dio.dart';

class AuthErrorMapper {
  static String map(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['code'] != null) {
        return 'errors.${data['code']}';
      }

      if (error.type == DioExceptionType.connectionTimeout) {
        return 'errors.TIMEOUT';
      }
    }

    if (error is StateError) {
      return 'errors.${error.message}';
    }

    return 'errors.UNKNOWN_ERROR';
  }
}
