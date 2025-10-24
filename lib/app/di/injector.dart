import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:obywatel_plus/app/config/env.dart';
import '../../core/logger/app_logger.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/features/auth/data/remote/auth_api.dart';
import 'package:obywatel_plus/app/config/app_config.dart';

final sl = GetIt.instance;

class AppInjector {
  static Future<void> setup() async {
    // ✅ Rejestracja konfiguracji środowiska
    final config = Env.config;
    sl.registerLazySingleton<AppConfig>(() => config);

    // ✅ Secure storage
    sl.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService(const FlutterSecureStorage()),
    );

    // ✅ Dio z wykorzystaniem configu
    sl.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: config.baseUrl,
          connectTimeout: Duration(seconds: config.connectTimeout),
          receiveTimeout: Duration(seconds: config.receiveTimeout),
        ),
      ),
    );

    // ✅ ApiClient
    sl.registerLazySingleton<ApiClient>(
      () => ApiClient(sl<Dio>(), sl<SecureStorageService>()),
    );

    // ✅ Auth API
    sl.registerLazySingleton<AuthApi>(() => AuthApi(baseUrl: config.baseUrl));

    // ✅ Logger
    sl.registerLazySingleton<AppLogger>(() => AppLogger());

    sl<AppLogger>().i(
      "✅ AppInjector: all dependencies registered (${Env.current.name})",
    );
  }
}
