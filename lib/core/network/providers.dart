import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_client.dart';

import 'package:obywatel_plus/core/network/dio_factory.dart';
import 'package:obywatel_plus/core/network/public_client.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';

final publicDioProvider = Provider<Dio>((ref) {
  return DioFactory.create(
    profile: DioProfile.public,
    logger: ref.watch(appLoggerProvider),
  );
});

final authDioProvider = Provider<Dio>((ref) {
  return DioFactory.create(
    profile: DioProfile.authenticated,
    logger: ref.watch(appLoggerProvider),
    storage: ref.watch(secureStorageProvider),
    sessionService: ref.watch(sessionServiceProvider.notifier),
  );
});

final publicApiClientProvider = Provider<PublicApiClient>((ref) {
  return PublicApiClient(
    dio: ref.watch(publicDioProvider),
    logger: ref.watch(appLoggerProvider),
  );
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    dio: ref.watch(authDioProvider),
    storage: ref.watch(secureStorageProvider),
    logger: ref.watch(appLoggerProvider),
  );
});
