import 'dart:async';

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
import 'package:obywatel_plus/core/network/clients/no_auth_client.dart';
import 'package:obywatel_plus/core/network/clients/public_client.dart';
import 'package:obywatel_plus/core/network/dio_factory.dart';
import 'package:obywatel_plus/core/network/interceptors/device_fingerprint_interceptor.dart';
import 'package:obywatel_plus/core/network/interceptors/global_error_interceptor.dart';
import 'package:obywatel_plus/core/network/interceptors/logging_interceptor.dart';
import 'package:obywatel_plus/core/network/network_manager.dart';
import 'package:obywatel_plus/core/network/token_storage_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
void globalWebSocketLifecycle(Ref ref) {
  final logger = ref.watch(appLoggerProvider);
  final client = ref.watch(appWebSocketClientProvider);
  String? lastAccessToken;

  Future<void> syncWithAuth(AuthState authState) async {
    logger.d(
      '[WS-LIFECYCLE][1] syncWithAuth start authState=$authState isAuthenticated=${authState.isAuthenticated}',
      module: 'WS-LIFECYCLE',
    );

    if (!authState.isAuthenticated) {
      logger.d(
        '[WS-LIFECYCLE][2] auth not authenticated; closing ws if needed. lastAccessToken=${lastAccessToken != null} isConnected=${client.isConnected}',
        module: 'WS-LIFECYCLE',
      );
      if (lastAccessToken != null || client.isConnected) {
        lastAccessToken = null;
        await client.disconnect();
      }
      return;
    }

    final token = await ref.read(authFreshProvider).token;
    final accessToken = token?.accessToken ?? '';
    logger.d(
      '[WS-LIFECYCLE][3] token resolved accessTokenPresent=${accessToken.isNotEmpty} lastAccessToken=${lastAccessToken != null} clientConnected=${client.isConnected}',
      module: 'WS-LIFECYCLE',
    );

    if (accessToken.isEmpty) {
      lastAccessToken = null;
      await client.disconnect();
      return;
    }

    final networkState = ref.read(networkStateProvider).asData?.value ??
        NetworkState.online;
    logger.d(
      '[WS-LIFECYCLE][4] networkState=$networkState',
      module: 'WS-LIFECYCLE',
    );
    if (networkState == NetworkState.offline) {
      logger.d(
        '[WS-LIFECYCLE][5] offline -> skip connect',
        module: 'WS-LIFECYCLE',
      );
      return;
    }

    if (lastAccessToken == accessToken && client.isConnected) {
      logger.d(
        '[WS-LIFECYCLE][6] token unchanged and socket connected -> skip reconnect',
        module: 'WS-LIFECYCLE',
      );
      return;
    }

    lastAccessToken = accessToken;

    final deviceFingerprint = await ref
        .read(deviceInfoServiceProvider)
        .getFingerprint();
    final normalizedBaseUrl = ServicesConfig.apiBaseUrl
        .replaceFirst('https://', 'wss://')
        .replaceFirst('http://', 'ws://')
        .replaceAll(RegExp(r'/+$'), '');
    final wsUrl = '$normalizedBaseUrl${ApiEndpoints.wsMessaging}';

    logger.i('[WS-LIFECYCLE] Inicjalizacja połączenia WS pod adres: $wsUrl');
    logger.d(
      '[WS-LIFECYCLE][7] attempt connect sessionKeyPresent=${accessToken.isNotEmpty} headersPresent=${deviceFingerprint.isNotEmpty}',
      module: 'WS-LIFECYCLE',
    );

    await client.connect(
      wsUrl,
      sessionKey: accessToken,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'X-Device-Fingerprint': deviceFingerprint,
      },
    );
  }

  ref.listen<AuthState>(authControllerProvider, (_, next) {
    unawaited(syncWithAuth(next));
  });

  ref.listen<AsyncValue<NetworkState>>(networkStateProvider, (_, next) {
    final state = next.asData?.value ?? NetworkState.unknown;
    if (state == NetworkState.offline) {
      unawaited(client.disconnect());
      return;
    }

    if (state == NetworkState.online) {
      unawaited(syncWithAuth(ref.read(authControllerProvider)));
    }
  });

  ref.onDispose(() async {
    lastAccessToken = null;
    await client.disconnect();
  });

  unawaited(syncWithAuth(ref.read(authControllerProvider)));
}

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
  final networkManager = ref.watch(networkManagerProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: ServicesConfig.apiBaseUrl,
      connectTimeout: Duration(seconds: apiConstants.connectTimeoutSeconds),
      receiveTimeout: Duration(seconds: apiConstants.receiveTimeoutSeconds),
      headers: {'Content-Type': 'application/json'},
      validateStatus: (status) {
        return status != null &&
            ((status >= 200 && status < 300) || status == 304);
      },
    ),
  );

  dio.interceptors.add(LoggingInterceptor(logger: logger));
  dio.interceptors.add(ref.watch(authFreshProvider));
  dio.interceptors.add(DeviceFingerprintInterceptor(ref));
  dio.interceptors.add(SecuritySyncInterceptor(ref));
  dio.interceptors.add(
    GlobalErrorInterceptor(logger: logger, networkManager: networkManager),
  );

  return dio;
}

@Riverpod(keepAlive: true)
Dio refreshDio(Ref ref) {
  return createDioInstance(
    profile: DioProfile.refreshToken,
    logger: ref.watch(appLoggerProvider),
    deviceInfoRef: ref,
    networkManager: ref.watch(networkManagerProvider),
  );
}

@Riverpod(keepAlive: true)
Dio noAuthDio(Ref ref) {
  final dio = createDioInstance(
    profile: DioProfile.noAuthAuth,
    logger: ref.watch(appLoggerProvider),
    deviceInfoRef: ref,
    networkManager: ref.watch(networkManagerProvider),
  );
  dio.interceptors.add(SecuritySyncInterceptor(ref));
  return dio;
}

@Riverpod(keepAlive: true)
Dio publicDio(Ref ref) {
  final dio = createDioInstance(
    profile: DioProfile.public,
    logger: ref.watch(appLoggerProvider),
    deviceInfoRef: ref,
    networkManager: ref.watch(networkManagerProvider),
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
AppWebSocketClient appWebSocketClient(Ref ref) {
  final client = AppWebSocketClient(logger: ref.watch(appLoggerProvider));
  ref.onDispose(client.dispose);
  return client;
}

@Riverpod(keepAlive: true)
Stream<WsConnectionStatus> appWebSocketStatus(Ref ref) {
  return ref.watch(appWebSocketClientProvider).statusStream;
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

