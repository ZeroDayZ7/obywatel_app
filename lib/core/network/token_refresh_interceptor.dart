import 'dart:async';

import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';

/// Interceptor zarządzający automatycznym odświeżaniem tokena JWT.
/// Używa [QueuedInterceptor], aby wstrzymać kolejkę żądań podczas odświeżania.
class TokenRefreshInterceptor extends QueuedInterceptor {
  final Dio _dio; // Klient główny do ponowienia zapytania
  final SecureStorageService _storage;
  final AppLogger _logger;
  final SessionService _sessionService;
  final Dio _refreshClient; // Dedykowany klient do odświeżania

  // MUTEX: Ten statyczny completer sprawia, że tylko jedno żądanie wykonuje refresh,
  // a pozostałe czekają na jego wynik.
  static Completer<String?>? _refreshCompleter;

  TokenRefreshInterceptor(
    this._dio,
    this._storage,
    this._logger,
    this._sessionService,
    this._refreshClient,
  );

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 1. Sprawdź czy błąd to 401 i czy nie dotyczy endpointów pomijanych
    if (err.response?.statusCode != 401 ||
        _isExcluded(err.requestOptions.path)) {
      return handler.next(err);
    }

    final requestOptions = err.requestOptions;

    // 2. Jeśli refresh już trwa (Mutex jest aktywny), czekaj na wynik
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

    // 3. Rozpocznij proces odświeżania (zablokuj Mutex)
    _refreshCompleter = Completer<String?>();
    _logger.i('🔒 401 detected → initiating token refresh');

    try {
      final refreshToken = await _storage.read(key: StorageKeys.refreshToken);
      if (refreshToken == null) throw Exception('No refresh token available');

      // Wywołanie refreshu za pomocą dedykowanego klienta
      final response = await _refreshClient.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      // Parsowanie nowych tokenów
      final newAccessToken =
          response.data['access_token'] ??
          response.data[StorageKeys.accessToken];
      final newRefreshToken =
          response.data['refresh_token'] ??
          response.data[StorageKeys.refreshToken];

      if (newAccessToken == null) throw Exception('New access token is null');

      // Zapis do bezpiecznego magazynu
      await _storage.write(key: StorageKeys.accessToken, value: newAccessToken);
      if (newRefreshToken != null) {
        await _storage.write(
          key: StorageKeys.refreshToken,
          value: newRefreshToken,
        );
      }

      _logger.i('🔓 Token refreshed successfully');

      // 4. Sukces: Powiadom oczekujące żądania i zwolnij blokadę
      _refreshCompleter?.complete(newAccessToken);
      _refreshCompleter = null;

      // Ponów oryginalne zapytanie
      handler.resolve(await _retryRequest(requestOptions, newAccessToken));
    } catch (e, stack) {
      _logger.e(
        '❌ Token refresh failed → clearing session',
        error: e,
        stackTrace: stack,
      );

      // Błąd: Powiadom oczekujące żądania o niepowodzeniu i zwolnij blokadę
      _refreshCompleter?.complete(null);
      _refreshCompleter = null;

      // Wyloguj użytkownika
      await _sessionService.clearSession();
      handler.next(err);
    }
  }

  /// Pomocnicza metoda do ponowienia żądania z nowym tokenem
  Future<Response> _retryRequest(RequestOptions options, String token) {
    options.headers['Authorization'] = 'Bearer $token';
    return _dio.fetch(options);
  }

  /// Lista endpointów, które nie powinny wyzwalać odświeżania tokena
  bool _isExcluded(String path) {
    final excludedPaths = [
      ApiEndpoints.login,
      ApiEndpoints.register,
      ApiEndpoints.refreshToken,
      ApiEndpoints.twoFaVerify,
      ApiEndpoints.twoFaResend,
      ApiEndpoints.logout,
    ];
    return excludedPaths.contains(path);
  }
}
