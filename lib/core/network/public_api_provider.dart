import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/public_api_client.dart';

final publicApiClientProvider = Provider<PublicApiClient>((ref) {
  return PublicApiClient(
    dio: Dio(),
    logger: ref.read(appLoggerProvider),
  );
});
