import 'package:dio/dio.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/app/config/services_config.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/core/network/global_error_interceptor.dart';
import 'package:obywatel_plus/core/network/token_refresh_interceptor.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';

enum DioProfile { public, authenticated }

class DioFactory {
  static Dio create({
    required DioProfile profile,
    required AppLogger logger,
    SecureStorageService? storage,
    SessionService? sessionService,
  }) {
    // Dynamiczny baseUrl w zależności od profilu
    final String baseUrl = switch (profile) {
      DioProfile.public => ServicesConfig.versionBaseUrl,
      DioProfile.authenticated => ServicesConfig.authBaseUrl,
    };

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: apiConstants.connectTimeoutSeconds),
        receiveTimeout: Duration(seconds: apiConstants.receiveTimeoutSeconds),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Wspólne interceptory dla obu profili
    dio.interceptors.add(_createLoggingInterceptor(logger));
    dio.interceptors.add(GlobalErrorInterceptor());

    // Tylko dla authenticated – auth + refresh token
    if (profile == DioProfile.authenticated &&
        storage != null &&
        sessionService != null) {
      dio.interceptors.add(_createAuthInterceptor(storage));
      dio.interceptors.add(
        TokenRefreshInterceptor(dio, storage, logger, sessionService),
      );
    }

    return dio;
  }

  /// Dodaje Bearer token do requestów
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

  /// Spójne logowanie dla całej apki
  static Interceptor _createLoggingInterceptor(AppLogger logger) {
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
