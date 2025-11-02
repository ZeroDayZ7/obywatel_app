import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:obywatel_plus/app/config/env.dart';

import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/api_client.dart';
import 'package:obywatel_plus/core/crypto/hash_service.dart';
import 'package:obywatel_plus/core/crypto/pin_service.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/security/security_service.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_service.dart';

import 'package:local_auth/local_auth.dart';
// import 'package:obywatel_plus/app/bootstrap/startup_service.dart';
// import 'package:obywatel_plus/app/bootstrap/version_service.dart';
// import 'package:obywatel_plus/app/bootstrap/migration_service.dart';
// import 'package:obywatel_plus/app/bootstrap/remote_config_service.dart';

final sl = GetIt.instance;

class AppInjector {
  static Future<void> setup() async {
    sl.registerLazySingleton<AppLogger>(() => AppLogger());
    sl.registerLazySingleton<HashService>(() => HashService(sl<AppLogger>()));
    sl.registerLazySingleton<PinService>(
      () => PinService(
        storage: const FlutterSecureStorage(),
        hashService: sl<HashService>(),
        logger: sl<AppLogger>(),
      ),
    );
    // Rejestracja LocalAuthentication
    sl.registerLazySingleton<LocalAuthentication>(() => LocalAuthentication());

    // Rejestracja SecureStorageService
    sl.registerLazySingleton<SecureStorageService>(
      () => SecureStorageService(const FlutterSecureStorage()),
    );

    // Rejestracja SecurityService korzystającego z DI
    sl.registerLazySingleton<SecurityService>(
      () => SecurityService(
        pinService: sl<PinService>(),
        secureStorage: sl<SecureStorageService>(),
        localAuth: sl<LocalAuthentication>(),
        logger: sl<AppLogger>(),
      ),
    );

    // Reszta rejestracji
    sl.registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: apiConstants.baseUrl,
          connectTimeout: Duration(seconds: apiConstants.connectTimeoutSeconds),
          receiveTimeout: Duration(seconds: apiConstants.receiveTimeoutSeconds),
        ),
      ),
    );

    sl.registerLazySingleton<ApiClient>(
      () => ApiClient(
        dio: sl<Dio>(),
        tokenRefreshDio: Dio(),
        storage: sl<SecureStorageService>(),
        logger: sl<AppLogger>(),
      ),
    );

    // sl.registerLazySingleton<VersionService>(
    //   () => VersionService(sl<ApiClient>(), sl<AppLogger>()),
    // );
    // sl.registerLazySingleton<MigrationService>(
    //   () => MigrationService(sl<SecureStorageService>(), sl<AppLogger>()),
    // );
    // sl.registerLazySingleton<RemoteConfigService>(
    //   () => RemoteConfigService(
    //     sl<ApiClient>(),
    //     sl<SecureStorageService>(),
    //     sl<AppLogger>(),
    //   ),
    // );

    // sl.registerLazySingleton<StartupService>(
    //   () => StartupService(
    //     storage: sl<SecureStorageService>(),
    //     api: sl<ApiClient>(),
    //     logger: sl<AppLogger>(),
    //     versionService: sl<VersionService>(),
    //     migrationService: sl<MigrationService>(),
    //     remoteConfigService: sl<RemoteConfigService>(),
    //   ),
    // );

    sl.registerLazySingleton<AuthService>(
      () => AuthService(
        apiClient: sl<ApiClient>(),
        storage: sl<SecureStorageService>(),
        logger: sl<AppLogger>(),
      ),
    );

    // sl.registerLazySingleton<PinService>(
    //   () => PinService(const FlutterSecureStorage()),
    // );
    // Factory dla controllers: sl.registerFactory<LoginController>(() => LoginController(service: sl<LoginService>(), ref: /* pass ref in use */));
  }
}
