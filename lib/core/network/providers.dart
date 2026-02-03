import 'package:dio/dio.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:obywatel_plus/app/config/services_config.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/backend_sync.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/clients/public_client.dart';
import 'package:obywatel_plus/core/network/dio_factory.dart';
import 'package:obywatel_plus/core/network/token_storage_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

// --- NOWY PROVIDER DLA FRESH ---
@Riverpod(keepAlive: true)
Fresh<OAuth2Token> authFresh(Ref ref) {
  return Fresh.oAuth2(
    tokenStorage: ref.watch(tokenStorageProvider),
    refreshToken: (token, client) async {
      final deviceService = ref.read(deviceInfoServiceProvider);
      final authState = ref.read(authControllerProvider);

      final userId = authState.maybeWhen(
        authenticated: (id, accessToken, refreshToken, isDeviceTrusted) => id,
        orElse: () => '',
      );
      // final userId = authState.maybeWhen(
      //   authenticated: (id, _, _, _) => id,
      //   orElse: () => '',
      // );

      if (userId.isEmpty) {
        throw Exception('Refresh failed: No authenticated user ID found');
      }

      final fingerprint = await deviceService.getFingerprint();
      final response = await client.post(
        '${ServicesConfig.authBaseUrl}${ApiEndpoints.refreshToken}',
        data: {StorageKeys.refreshToken: token?.refreshToken},
        options: Options(headers: {'X-Device-Fingerprint': fingerprint}),
      );

      return OAuth2Token(
        accessToken: response.data[StorageKeys.accessToken],
        refreshToken: response.data[StorageKeys.refreshToken],
      );
    },
    shouldRefresh: (response) => response?.statusCode == 401,
  );
}

// --- ZAKTUALIZOWANY AUTH DIO ---
@Riverpod(keepAlive: true)
Dio authDio(Ref ref) {
  final dio = DioFactory.create(
    profile: DioProfile.authenticated,
    logger: ref.watch(appLoggerProvider),
    deviceInfoRef: ref,
  );

  dio.interceptors.add(SecuritySyncInterceptor(ref));

  // Wstrzykujemy Fresh z osobnego providera
  dio.interceptors.add(ref.watch(authFreshProvider));

  return dio;
}

// --- RESZTA POZOSTAJE BEZ ZMIAN ---

@Riverpod(keepAlive: true)
Dio refreshDio(Ref ref) {
  return DioFactory.create(
    profile: DioProfile.refreshToken,
    logger: ref.watch(appLoggerProvider),
    deviceInfoRef: ref,
  );
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
Dio resetDio(Ref ref) {
  final dio = DioFactory.create(
    profile: DioProfile.noAuthAuth,
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
PublicApiClient publicApiClient(Ref ref) {
  return PublicApiClient(
    dio: ref.watch(publicDioProvider),
    logger: ref.watch(appLoggerProvider),
  );
}

@Riverpod(keepAlive: true)
PublicApiClient resetApiClient(Ref ref) {
  return PublicApiClient(
    dio: ref.watch(resetDioProvider),
    logger: ref.watch(appLoggerProvider),
  );
}
