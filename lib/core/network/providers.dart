import 'package:dio/dio.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:obywatel_plus/app/config/services_config.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_client.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/dio_factory.dart';
import 'package:obywatel_plus/core/network/public_client.dart';
import 'package:obywatel_plus/core/network/token_storage_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

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
  return DioFactory.create(
    profile: DioProfile.public,
    logger: ref.watch(appLoggerProvider),
    deviceInfoRef: ref,
  );
}

@Riverpod(keepAlive: true)
Dio resetDio(Ref ref) {
  return DioFactory.create(
    profile: DioProfile.noAuthAuth,
    logger: ref.watch(appLoggerProvider),
    deviceInfoRef: ref,
  );
}

@Riverpod(keepAlive: true)
Dio authDio(Ref ref) {
  final logger = ref.watch(appLoggerProvider);

  final dio = DioFactory.create(
    profile: DioProfile.authenticated,
    logger: logger,
    deviceInfoRef: ref,
  );

  final fresh = Fresh.oAuth2(
    tokenStorage: ref.watch(tokenStorageProvider),
    refreshToken: (token, client) async {
      final deviceService = ref.read(deviceInfoServiceProvider);
      final authState = ref.read(authControllerProvider);
      final userId = authState.maybeWhen(
        authenticated: (id, _, _, _, _) => id.toString(),
        orElse: () => '',
      );
      if (userId.isEmpty) {
        throw Exception(
          'Refresh failed: No authenticated user ID found in state',
        );
      }

      final fingerprint = await deviceService.getSecureFingerprint();
      final response = await client.post(
        '${ServicesConfig.authBaseUrl}${ApiEndpoints.refreshToken}',
        data: {'refresh_token': token?.refreshToken},
        options: Options(headers: {'X-Device-Fingerprint': fingerprint}),
      );

      return OAuth2Token(
        accessToken: response.data['access_token'],
        refreshToken: response.data['refresh_token'],
      );
    },
    shouldRefresh: (response) => response?.statusCode == 401,
  );

  dio.interceptors.add(fresh);

  // fresh.authenticationStatus.listen((status) {
  //   if (status == AuthenticationStatus.unauthenticated) {
  //     ref.read(sessionStatusProvider.notifier).reportInvalidSession();
  //     ref.read(authControllerProvider.notifier).logout();
  //   }
  // });

  return dio;
}

@Riverpod(keepAlive: true)
PublicApiClient publicApiClient(Ref ref) {
  return PublicApiClient(
    dio: ref.watch(publicDioProvider),
    logger: ref.watch(appLoggerProvider),
  );
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
PublicApiClient resetApiClient(Ref ref) {
  return PublicApiClient(
    dio: ref.watch(resetDioProvider),
    logger: ref.watch(appLoggerProvider),
  );
}
