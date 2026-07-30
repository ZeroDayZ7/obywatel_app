import 'package:dio/dio.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/app/config/services_config.dart';
import 'package:obywatel_plus/core/errors/exceptions/app_exception.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/backend_sync.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/clients/app_websocket_client.dart';
import 'package:obywatel_plus/core/network/clients/device_fingerprint_interceptor.dart';
import 'package:obywatel_plus/core/network/clients/no_auth_client.dart';
import 'package:obywatel_plus/core/network/clients/public_client.dart';
import 'package:obywatel_plus/core/network/dio_factory.dart';
import 'package:obywatel_plus/core/network/interceptors/global_error_interceptor.dart';
import 'package:obywatel_plus/core/network/interceptors/logging_interceptor.dart';
import 'package:obywatel_plus/core/network/token_storage_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
Fresh<OAuth2Token> authFresh(Ref ref) {
  return Fresh.oAuth2(
    tokenStorage: ref.watch(tokenStorageProvider),
    refreshToken: (token, client) async {
      final refreshToken = token?.refreshToken;

      if (refreshToken == null || refreshToken.isEmpty) {
        throw RevokedTokenException();
      }

      final refreshClient = ref.read(refreshDioProvider);
      final deviceService = ref.read(deviceInfoServiceProvider);
      final fingerprint = await deviceService.getFingerprint();

      try {
        final response = await refreshClient.post(
          ApiEndpoints.refresh,
          data: {StorageKeys.refreshToken: refreshToken},
          options: Options(headers: {'X-Device-Fingerprint': fingerprint}),
        );

        return OAuth2Token(
          accessToken: response.data[StorageKeys.accessToken] as String,
          refreshToken: response.data[StorageKeys.refreshToken] as String?,
        );
      } on DioException catch (e) {
        if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
          throw RevokedTokenException();
        }
        rethrow;
      }
    },
    shouldRefresh: (response) => response?.statusCode == 401,
  );
}

@Riverpod(keepAlive: true)
Dio authDio(Ref ref) {
  final logger = ref.watch(appLoggerProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: ServicesConfig.authBaseUrl,
      connectTimeout: Duration(seconds: apiConstants.connectTimeoutSeconds),
      receiveTimeout: Duration(seconds: apiConstants.receiveTimeoutSeconds),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // 1. Logging Interceptor
  dio.interceptors.add(LoggingInterceptor(logger: logger));

  // 2. Fresh Interceptor (musi być PRZED GlobalErrorInterceptor)
  dio.interceptors.add(ref.watch(authFreshProvider));

  // 3. Device Fingerprint
  dio.interceptors.add(DeviceFingerprintInterceptor(ref));

  // 4. Security Sync
  dio.interceptors.add(SecuritySyncInterceptor(ref));

  // 5. Global Error Interceptor (przetwarza błędy po nieudanej próbie refreshu)
  dio.interceptors.add(GlobalErrorInterceptor(logger: logger));

  return dio;
}

@Riverpod(keepAlive: true)
Dio refreshDio(Ref ref) {
  return DioFactory.create(
    profile: DioProfile.refreshToken,
    logger: ref.watch(appLoggerProvider),
    deviceInfoRef: ref,
  );
}

@Riverpod(keepAlive: true)
Dio noAuthDio(Ref ref) {
  final dio = DioFactory.create(
    profile: DioProfile.noAuthAuth,
    logger: ref.watch(appLoggerProvider),
    deviceInfoRef: ref,
  );
  dio.interceptors.add(SecuritySyncInterceptor(ref));
  return dio;
}

@Riverpod(keepAlive: true)
Dio publicDio(Ref ref) {
  final dio = DioFactory.create(
    profile: DioProfile.public,
    logger: ref.watch(appLoggerProvider),
    deviceInfoRef: ref,
  );
  dio.interceptors.add(SecuritySyncInterceptor(ref));
  return dio;
}

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  return ApiClient(
    dio: ref.watch(authDioProvider),
    storage: ref.watch(secureStorageProvider),
    logger: ref.watch(appLoggerProvider),
  );
}

@Riverpod(keepAlive: true)
NoAuthApiClient noAuthApiClient(Ref ref) {
  return NoAuthApiClient(
    dio: ref.watch(noAuthDioProvider),
    logger: ref.watch(appLoggerProvider),
  );
}

@Riverpod(keepAlive: true)
PublicApiClient publicApiClient(Ref ref) {
  return PublicApiClient(
    dio: ref.watch(publicDioProvider),
    logger: ref.watch(appLoggerProvider),
  );
}

@Riverpod(keepAlive: true)
AppWebSocketClient appWebSocketClient(Ref ref) {
  final logger = ref.watch(appLoggerProvider);
  final client = AppWebSocketClient(logger: logger);

  ref.onDispose(() {
    client.dispose();
  });

  return client;
}
