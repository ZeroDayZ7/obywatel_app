import 'dart:async';

import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';

class TokenRefreshInterceptor extends QueuedInterceptor {
  final Dio _dio;
  final SecureStorageService _storage;
  final AppLogger _logger;
  final SessionService _sessionService;
  final Dio _refreshClient;
  final void Function()? onRefreshFailure;

  static Completer<String?>? _refreshCompleter;

  TokenRefreshInterceptor(
    this._dio,
    this._storage,
    this._logger,
    this._sessionService,
    this._refreshClient,
    this.onRefreshFailure,
  );

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401 ||
        _isExcluded(err.requestOptions.path)) {
      return handler.next(err);
    }

    final requestOptions = err.requestOptions;

    if (_refreshCompleter != null) {
      _logger.i(
        '⏳ Refresh in progress, queuing request: ${requestOptions.path}',
      );
      final newToken = await _refreshCompleter!.future;
      if (newToken != null) {
        return handler.resolve(await _retryRequest(requestOptions, newToken));
      }
      return handler.next(err);
    }

    _refreshCompleter = Completer<String?>();
    _logger.i('🔒 401 detected → initiating token refresh');

    try {
      String? refreshToken = await _storage.read(key: StorageKeys.refreshToken);

      if (refreshToken == null || refreshToken.isEmpty) {
        throw Exception('No refresh token available');
      }

      final response = await _refreshClient.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      final newAccessToken =
          response.data['access_token'] ??
          response.data[StorageKeys.accessToken];
      final newRefreshToken =
          response.data['refresh_token'] ??
          response.data[StorageKeys.refreshToken];

      if (newAccessToken == null) throw Exception('New access token is null');

      await _storage.write(key: StorageKeys.accessToken, value: newAccessToken);
      if (newRefreshToken != null) {
        await _storage.write(
          key: StorageKeys.refreshToken,
          value: newRefreshToken,
        );
      }

      _logger.i('🔓 Token refreshed successfully');
      _refreshCompleter?.complete(newAccessToken);
      _refreshCompleter = null;

      handler.resolve(await _retryRequest(requestOptions, newAccessToken));
    } catch (e, stack) {
      _logger.e(
        '❌ Token refresh failed → clearing session',
        error: e,
        stackTrace: stack,
      );

      _refreshCompleter?.complete(null);
      _refreshCompleter = null;

      await _sessionService.clearSession();
      onRefreshFailure?.call();

      handler.next(err);
    }
  }

  Future<Response> _retryRequest(RequestOptions options, String token) {
    options.headers['Authorization'] = 'Bearer $token';
    return _dio.fetch(options);
  }

  bool _isExcluded(String path) {
    return [
      ApiEndpoints.login,
      ApiEndpoints.register,
      ApiEndpoints.refreshToken,
      ApiEndpoints.twoFaVerify,
      ApiEndpoints.twoFaResend,
      ApiEndpoints.logout,
    ].any((excluded) => path.contains(excluded));
  }
}
