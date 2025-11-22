import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/config/services_config.dart';
import 'package:obywatel_plus/core/network/api_client.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/app/config/env.dart';

// Provider dla Dio
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: ServicesConfig.authBaseUrl,
      connectTimeout: Duration(seconds: apiConstants.connectTimeoutSeconds),
      receiveTimeout: Duration(seconds: apiConstants.receiveTimeoutSeconds),
    ),
  );
});

// Provider dla ApiClient (lazy singleton w Riverpodzie)
final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  final logger = ref.watch(appLoggerProvider);
  final storage = ref.watch(secureStorageProvider);

  return ApiClient(
    dio: dio,
    tokenRefreshDio: Dio(),
    storage: storage,
    logger: logger,
  );
});
