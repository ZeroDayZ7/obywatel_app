import 'package:flutter_riverpod/legacy.dart';
import 'package:dio/dio.dart';
import 'package:obywatel_plus/app/config/env.dart';

// Stany połączenia
enum BackendStatus { loading, ok, error }

class BackendNotifier extends StateNotifier<BackendStatus> {
  BackendNotifier() : super(BackendStatus.loading) {
    checkBackend(); // automatycznie sprawdzamy backend przy tworzeniu
  }

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: Duration(seconds: ApiConstants.connectTimeoutSeconds),
      receiveTimeout: Duration(seconds: ApiConstants.receiveTimeoutSeconds),
    ),
  );

  Future<void> checkBackend() async {
    state = BackendStatus.loading;
    try {
      final response = await _dio.get(ApiConstants.pingEndpoint);
      state = (response.statusCode == 200)
          ? BackendStatus.ok
          : BackendStatus.error;
    } catch (_) {
      state = BackendStatus.error;
    }
  }
}

final backendProvider = StateNotifierProvider<BackendNotifier, BackendStatus>((
  ref,
) {
  return BackendNotifier();
});
