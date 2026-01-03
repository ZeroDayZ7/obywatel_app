import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_client.dart';
import 'package:obywatel_plus/core/network/dio_factory.dart';
import 'package:obywatel_plus/core/network/public_client.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
Dio refreshDio(Ref ref) {
  // Zamienione na Ref
  return DioFactory.create(
    profile: DioProfile.refreshToken,
    logger: ref.watch(appLoggerProvider),
    deviceInfoRef: ref,
  );
}

@Riverpod(keepAlive: true)
Dio publicDio(Ref ref) {
  // Zamienione na Ref
  return DioFactory.create(
    profile: DioProfile.public,
    logger: ref.watch(appLoggerProvider),
    deviceInfoRef: ref,
  );
}

@Riverpod(keepAlive: true)
Dio resetDio(Ref ref) {
  // Zamienione na Ref
  return DioFactory.create(
    profile: DioProfile.noAuthAuth,
    logger: ref.watch(appLoggerProvider),
    deviceInfoRef: ref,
  );
}

@Riverpod(keepAlive: true)
Dio authDio(Ref ref) {
  // Zamienione na Ref
  return DioFactory.create(
    profile: DioProfile.authenticated,
    logger: ref.watch(appLoggerProvider),
    storage: ref.watch(secureStorageProvider),
    sessionService: ref.watch(sessionServiceProvider),
    refreshClient: ref.watch(refreshDioProvider),
    accessTokenGetter: () => ref
        .read(authControllerProvider)
        .mapOrNull(authenticated: (s) => s.accessToken),
    onRefreshFailure: () {
      ref.read(authControllerProvider.notifier).logout();
    },
    deviceInfoRef: ref,
  );
}

@Riverpod(keepAlive: true)
PublicApiClient publicApiClient(Ref ref) {
  // Zamienione na Ref
  return PublicApiClient(
    dio: ref.watch(publicDioProvider),
    logger: ref.watch(appLoggerProvider),
  );
}

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  // Zamienione na Ref
  return ApiClient(
    dio: ref.watch(authDioProvider),
    storage: ref.watch(secureStorageProvider),
    logger: ref.watch(appLoggerProvider),
  );
}

@Riverpod(keepAlive: true)
PublicApiClient resetApiClient(Ref ref) {
  // Zamienione na Ref
  return PublicApiClient(
    dio: ref.watch(resetDioProvider),
    logger: ref.watch(appLoggerProvider),
  );
}
