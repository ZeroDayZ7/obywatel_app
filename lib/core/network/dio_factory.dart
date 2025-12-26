import 'package:dio/dio.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/app/config/services_config.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/core/network/global_error_interceptor.dart';
import 'package:obywatel_plus/core/network/token_refresh_interceptor.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';

// 1. Dodajemy profil 'refreshToken'
enum DioProfile { public, authenticated, refreshToken }

class DioFactory {
  static Dio create({
    required DioProfile profile,
    required AppLogger logger,
    SecureStorageService? storage,
    SessionService? sessionService,
    Dio? refreshClient, // 2. Opcjonalny klient do wstrzyknięcia
  }) {
    // 3. Konfiguracja Base URL
    final String baseUrl = switch (profile) {
      DioProfile.public => ServicesConfig.versionBaseUrl,
      // Refresh token uderza w ten sam endpoint co Auth
      DioProfile.authenticated ||
      DioProfile.refreshToken => ServicesConfig.authBaseUrl,
    };

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: apiConstants.connectTimeoutSeconds),
        receiveTimeout: Duration(seconds: apiConstants.receiveTimeoutSeconds),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Wspólne interceptory (logowanie, błędy)
    dio.interceptors.add(_createLoggingInterceptor(logger));
    dio.interceptors.add(GlobalErrorInterceptor());

    // 4. Logika dla Authenticated - tu wstrzykujemy refreshClient
    if (profile == DioProfile.authenticated &&
        storage != null &&
        sessionService != null &&
        refreshClient != null) {
      // Wymagamy refreshClienta

      dio.interceptors.add(_createAuthInterceptor(storage));

      dio.interceptors.add(
        TokenRefreshInterceptor(
          dio,
          storage,
          logger,
          sessionService,
          refreshClient, // Przekazujemy instancję
        ),
      );
    }

    // Profil 'refreshToken' nie dostaje żadnych dodatkowych interceptorów auth/refresh!

    return dio;
  }

  static Interceptor _createAuthInterceptor(SecureStorageService storage) {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storage.read(key: StorageKeys.accessToken);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    );
  }

  static Interceptor _createLoggingInterceptor(AppLogger logger) {
    // ... bez zmian ...
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        logger.i('➡️ ${options.method} ${options.uri}');
        if (options.data != null) {
          logger.i('Body: ${options.data}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        logger.i('⬅️ ${response.statusCode} ${response.requestOptions.uri}');
        handler.next(response);
      },
      onError: (error, handler) {
        final status = error.response?.statusCode ?? 'no_response';
        logger.e('❌ $status ${error.requestOptions.uri}', error: error);
        handler.next(error);
      },
    );
  }
}
