import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/logger/app_logger.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/secure_storage_service.dart';

final sl = GetIt.instance;

class AppInjector {
  static Future<void> setup() async {
    // Rejestracja usług
    sl.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService(const FlutterSecureStorage()),
    );

    sl.registerLazySingleton<Dio>(
      () => Dio(BaseOptions(baseUrl: 'https://api.twojbackend.pl')),
    );

    sl.registerLazySingleton<ApiClient>(
      () => ApiClient(sl<Dio>(), sl<SecureStorageService>()),
    );

    // Jeden logger dla całej aplikacji
    sl.registerLazySingleton<AppLogger>(() => AppLogger());

    // Testowy log po rejestracji
    sl<AppLogger>().i("AppInjector: all dependencies registered ✅");
  }
}
