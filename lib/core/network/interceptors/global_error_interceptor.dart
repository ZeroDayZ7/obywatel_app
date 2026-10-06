import 'dart:io';

import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/errors/exceptions/app_exception.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/network_manager.dart';

class GlobalErrorInterceptor extends Interceptor {
  final AppLogger logger;
  final NetworkManager networkManager;

  final int maxRetries;
  final Duration retryDelay;
  final Duration backendCooldown;

  GlobalErrorInterceptor({
    required this.logger,
    required this.networkManager,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 5),
    this.backendCooldown = const Duration(seconds: 30),
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (networkManager.shouldFailFast()) {
      final isOffline = networkManager.state == NetworkState.offline;
      final error = DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
        error: isOffline
            ? const NetworkException()
            : const BackendUnavailableException(),
      );

      logger.w(
        '[NETWORK] Blocked request while ${isOffline ? 'offline' : 'backend unavailable'}',
        module: 'NETWORK',
      );

      return handler.reject(error);
    }

    return handler.next(options);
  }

  AppException mapToException(DioException error) => _mapToException(error);

  bool shouldRetry(DioException error) => _shouldRetry(error, mapToException(error));

  bool isHardBackendUnavailable(DioException error) => _isHardBackendUnavailable(error);

  bool shouldOpenCircuitImmediately(DioException error) =>
      _isHardBackendUnavailable(error);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
    final appException = mapToException(err);

    if (shouldOpenCircuitImmediately(err)) {
      networkManager.markBackendUnavailable(cooldown: backendCooldown);
      logger.w(
        '[NETWORK] Hard backend failure detected for ${requestOptions.path}; circuit opened immediately',
        module: 'NETWORK',
        error: err,
      );

      return handler.reject(
        DioException(
          requestOptions: requestOptions,
          response: err.response,
          type: err.type,
          error: const BackendUnavailableException(),
        ),
      );
    }

    if (shouldRetry(err)) {
      final retryCount = requestOptions.extra['retry_count'] as int? ?? 0;
      final nextRetry = retryCount + 1;

      if (nextRetry <= maxRetries) {
        requestOptions.extra['retry_count'] = nextRetry;
        networkManager.markRetrying();

        final delay = retryDelay;
        logger.w(
          '[NETWORK] Retry $nextRetry/$maxRetries in ${delay.inSeconds}s for ${requestOptions.path}',
          module: 'NETWORK',
        );

        await Future<void>.delayed(delay);

        try {
          final retryResponse = await _retryRequest(requestOptions);
          requestOptions.extra['retry_count'] = 0;
          return handler.resolve(retryResponse);
        } on DioException catch (retryError) {
          return onError(retryError, handler);
        }
      }

      networkManager.markBackendUnavailable(cooldown: backendCooldown);
      logger.w(
        '[NETWORK] Circuit opened for ${backendCooldown.inSeconds}s after $maxRetries attempts',
        module: 'NETWORK',
      );

      return handler.reject(
        DioException(
          requestOptions: requestOptions,
          response: err.response,
          type: err.type,
          error: const BackendUnavailableException(),
        ),
      );
    }

    if (appException is NetworkException &&
        networkManager.state == NetworkState.offline) {
      networkManager.resetAfterConnectivityRecovery();
    }

    logger.e(
      '[NETWORK] ${appException.runtimeType}: ${appException.message}',
      module: 'NETWORK',
      error: err,
    );

    return handler.reject(
      DioException(
        requestOptions: requestOptions,
        response: err.response,
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
    if (exception is NetworkException) {
      return true;
    }

    if (exception is TimeoutException) {
      return true;
    }

    if (exception is UpstreamUnavailableException) {
      return true;
    }

    if (error.response?.statusCode == 502 ||
        error.response?.statusCode == 503 ||
        error.response?.statusCode == 504) {
      return true;
    }

    return false;
  }

  bool _isHardBackendUnavailable(DioException error) {
    if (networkManager.state == NetworkState.offline) {
      return false;
    }

    final message = (error.message ?? error.error.toString()).toLowerCase();
    final socketException = error.error is SocketException
        ? error.error as SocketException
        : null;
    final socketMessage = socketException?.message.toLowerCase() ?? '';
    final socketErrorCode = socketException?.osError?.errorCode;

    final hardBackendRefusalCodes = {
      61,
      111,
      1225,
      10061,
    };

    final isRefusedByPeer =
        socketErrorCode != null && hardBackendRefusalCodes.contains(socketErrorCode);

    final isConnectionRefusedText =
        message.contains('connection refused') ||
        message.contains('refused the connection') ||
        message.contains('failed to connect to') ||
        message.contains('connection reset by peer') ||
        message.contains('no route to host') ||
        message.contains('odrzucił połączenie') ||
        message.contains('odrzucił połączenie') ||
        socketMessage.contains('connection refused') ||
        socketMessage.contains('refused the connection') ||
        socketMessage.contains('failed to connect to') ||
        socketMessage.contains('connection reset by peer') ||
        socketMessage.contains('no route to host') ||
        socketMessage.contains('odrzucił połączenie') ||
        socketMessage.contains('odrzucił połączenie');

    if (error.type == DioExceptionType.connectionError &&
        (isRefusedByPeer || isConnectionRefusedText)) {
      return true;
    }

    return false;
  }

  AppException _mapToException(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final data = response?.data;

    if (error.error is BackendUnavailableException) {
      return const BackendUnavailableException();
    }

    if (_isHardBackendUnavailable(error)) {
      return const BackendUnavailableException();
    }

    if (networkManager.state == NetworkState.offline) {
      return const NetworkException();
    }

    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout) {
      return const NetworkException();
    }

    if (error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return const TimeoutException();
    }

    if (error.error is SocketException) {
      return const NetworkException();
    }

    if (_isUpstreamUnavailable(data)) {
      return const UpstreamUnavailableException();
    }

    if (statusCode == 502 || statusCode == 503 || statusCode == 504) {
      return const BackendUnavailableException();
    }

    if (statusCode == 401) {
      return const UnauthorizedException();
    }

    if (statusCode == 403) {
      return const ForbiddenException();
    }

    if (statusCode == 400) {
      return ValidationException(
        message: _extractMessage(data) ?? 'Niepoprawne dane.',
        code: _extractCode(data),
        statusCode: statusCode,
      );
    }

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
