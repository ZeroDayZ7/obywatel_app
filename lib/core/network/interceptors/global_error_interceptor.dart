import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/errors/exceptions/app_exception.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

class GlobalErrorInterceptor extends Interceptor {
  final AppLogger logger;

  final int maxRetries;
  final Duration initialRetryDelay;

  GlobalErrorInterceptor({
    required this.logger,
    this.maxRetries = 3,
    this.initialRetryDelay = const Duration(milliseconds: 800),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;

    final requestOptions = err.requestOptions;

    final appException = _mapToException(err);

    /*
      Retry wykonujemy tylko dla błędów tymczasowych.
      Nie retryujemy:
      - 401
      - 403
      - validation
      - parse
    */
    if (_shouldRetry(err, appException)) {
      final retryCount = requestOptions.extra['retry_count'] as int? ?? 0;

      final nextRetry = retryCount + 1;

      if (nextRetry <= maxRetries) {
        requestOptions.extra['retry_count'] = nextRetry;

        final delay = initialRetryDelay * (1 << (nextRetry - 1));

        logger.w(
          'NETWORK RETRY '
          '$nextRetry/$maxRetries '
          '${requestOptions.path} '
          'delay=${delay.inMilliseconds}ms',
          module: 'NETWORK',
        );

        await Future<void>.delayed(delay);

        try {
          final retryResponse = await _retryRequest(requestOptions);

          return handler.resolve(retryResponse);
        } on DioException catch (retryError) {
          return onError(retryError, handler);
        }
      }
    }

    logger.e(
      'NETWORK ERROR '
      '${appException.runtimeType}: '
      '${appException.message}',
      module: 'NETWORK',
      error: err,
    );

    return handler.reject(
      DioException(
        requestOptions: requestOptions,
        response: response,
        type: err.type,
        error: appException,
      ),
    );
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
    final retryDio = Dio(
      BaseOptions(
        baseUrl: requestOptions.baseUrl,
        connectTimeout: requestOptions.connectTimeout,
        receiveTimeout: requestOptions.receiveTimeout,
        headers: requestOptions.headers,
      ),
    );

    return retryDio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
        extra: requestOptions.extra,
        responseType: requestOptions.responseType,
        contentType: requestOptions.contentType,
      ),
    );
  }

  bool _shouldRetry(DioException error, AppException exception) {
    if (exception is UpstreamUnavailableException) {
      return true;
    }

    if (exception is TimeoutException) {
      return true;
    }

    if (error.response?.statusCode == 502 ||
        error.response?.statusCode == 503 ||
        error.response?.statusCode == 504) {
      return true;
    }

    return false;
  }

  AppException _mapToException(DioException error) {
    final response = error.response;

    final statusCode = response?.statusCode;

    final data = response?.data;

    /*
      Brak internetu
    */
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout) {
      return const NetworkException();
    }

    /*
      Timeout odpowiedzi
    */
    if (error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const TimeoutException();
    }

    /*
      Gateway nie może dostać się do mikroserwisu
    */
    if (_isUpstreamUnavailable(data)) {
      return const UpstreamUnavailableException();
    }

    /*
      Autoryzacja
    */
    if (statusCode == 401) {
      return const UnauthorizedException();
    }

    /*
      Uprawnienia
    */
    if (statusCode == 403) {
      return const ForbiddenException();
    }

    /*
      Błędy walidacji backendu
    */
    if (statusCode == 400) {
      return ValidationException(
        message: _extractMessage(data) ?? 'Niepoprawne dane.',
        code: _extractCode(data),
        statusCode: statusCode,
      );
    }

    /*
      Błędy serwera
    */
    if (statusCode != null && statusCode >= 500) {
      return ServerException(
        message: _extractMessage(data) ?? 'Błąd serwera.',
        code: _extractCode(data) ?? 'SERVER_ERROR',
        statusCode: statusCode,
      );
    }

    return UnknownException(
      message: error.message ?? 'Nieznany błąd komunikacji.',
    );
  }

  bool _isUpstreamUnavailable(dynamic data) {
    if (data is! Map) {
      return false;
    }

    final code = data['code']?.toString();

    return code == 'UPSTREAM_UNAVAILABLE' || code == 'UPSTREAM_UNREACHABLE';
  }

  String? _extractMessage(dynamic data) {
    if (data is Map) {
      return data['message']?.toString();
    }

    return null;
  }

  String? _extractCode(dynamic data) {
    if (data is Map) {
      return data['code']?.toString();
    }

    return null;
  }
}
