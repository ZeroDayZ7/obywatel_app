import 'package:dio/dio.dart';

import 'package:obywatel_plus/core/errors/failures/app_failure.dart';

AppFailure mapDioToFailure(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.connectionError:
      return const AppFailure.network();

    case DioExceptionType.badResponse:
      final status = e.response?.statusCode;
      final data = e.response?.data;

      if (status != null && status >= 500) {
        return AppFailure.server(statusCode: status);
      }

      if (data is Map && data['code'] != null) {
        return AppFailure.validation(messageKey: 'errors.${data['code']}');
      }

      return const AppFailure.unknown();

    case DioExceptionType.cancel:
      return const AppFailure.unknown();

    default:
      return const AppFailure.unknown();
  }
}
