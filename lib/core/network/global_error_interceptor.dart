import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/errors/error_mapper.dart';

class GlobalErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure = ErrorMapper.mapDioException(err);

    final modifiedError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: failure,
      stackTrace: err.stackTrace,
    );

    return handler.next(modifiedError);
  }
}
