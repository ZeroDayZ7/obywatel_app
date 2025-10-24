import 'package:flutter_riverpod/legacy.dart';
import 'package:dio/dio.dart';
import 'package:obywatel_plus/app/config/app_config.dart';
import 'package:obywatel_plus/app/di/injector.dart';

// Stany połączenia
enum BackendStatus { loading, ok, error }

class BackendNotifier extends StateNotifier<BackendStatus> {
  BackendNotifier() : super(BackendStatus.loading) {
    checkBackend(); // automatycznie sprawdzamy backend przy tworzeniu
  }

  final AppConfig _config = sl<AppConfig>();

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _config.baseUrl,
      connectTimeout: Duration(seconds: _config.connectTimeout),
      receiveTimeout: Duration(seconds: _config.receiveTimeout),
    ),
  );

  Future<void> checkBackend() async {
    state = BackendStatus.loading;
    try {
      final response = await _dio.get(_config.pingEndpoint);
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
