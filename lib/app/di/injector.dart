import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:obywatel_plus/app/config/env.dart';

import '../../core/logger/app_logger.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/features/auth/data/remote/auth_api.dart';

final sl = GetIt.instance;

class AppInjector {
  static Future<void> setup() async {
    // Rejestracja usług
    sl.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService(const FlutterSecureStorage()),
    );

    sl.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: Duration(seconds: ApiConstants.connectTimeoutSeconds),
          receiveTimeout: Duration(seconds: ApiConstants.receiveTimeoutSeconds),
        ),
      ),
    );

    sl.registerLazySingleton<ApiClient>(
      () => ApiClient(sl<Dio>(), sl<SecureStorageService>()),
    );

    sl.registerLazySingleton<AuthApi>(
      () => AuthApi(baseUrl: ApiConstants.baseUrl),
    );

    // Jeden logger dla całej aplikacji
    sl.registerLazySingleton<AppLogger>(() => AppLogger());

    // Testowy log po rejestracji
    sl<AppLogger>().i("AppInjector: all dependencies registered ✅");
  }
}
