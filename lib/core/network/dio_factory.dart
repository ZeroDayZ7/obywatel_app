import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/app/config/services_config.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/device_interceptor.dart';
import 'package:obywatel_plus/core/network/global_error_interceptor.dart';
import 'package:obywatel_plus/core/network/logging_interceptor.dart';
import 'package:obywatel_plus/core/network/token_refresh_interceptor.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';

enum DioProfile { public, authenticated, refreshToken, noAuthAuth }

class DioFactory {
  static Dio create({
    required DioProfile profile,
    required AppLogger logger,
    String? Function()? accessTokenGetter,
    void Function()? onRefreshFailure,
    SecureStorageService? storage,
    SessionService? sessionService,
    Dio? refreshClient,
    Ref? deviceInfoRef,
  }) {
    final String baseUrl = switch (profile) {
      DioProfile.public => ServicesConfig.versionBaseUrl,
      DioProfile.authenticated ||
      DioProfile.refreshToken ||
      DioProfile.noAuthAuth => ServicesConfig.authBaseUrl,
    };

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: apiConstants.connectTimeoutSeconds),
        receiveTimeout: Duration(seconds: apiConstants.receiveTimeoutSeconds),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // --- SSL PINNING ---
    if (!kIsWeb && apiConstants.enableSSLPinning) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () => HttpClient(),
        validateCertificate: (cert, host, port) {
          if (cert == null) return false;
          final serverFingerprint = _getFingerprint(cert.der);
          final bool isValid = serverFingerprint == apiConstants.apiFingerprint;

          if (!isValid) {
            logger.e('🚨 SSL Pinning Violation! Host: $host');
          }
          return isValid;
        },
      );
    }

    // --- INTERCEPTORY GLOBALNE ---
    dio.interceptors.addAll([
      if (deviceInfoRef != null) DeviceInterceptor(deviceInfoRef),
      LoggingInterceptor(logger: logger),
      GlobalErrorInterceptor(logger: logger),
    ]);

    // --- INTERCEPTORY AUTORYZACJI ---
    if (profile == DioProfile.authenticated &&
        storage != null &&
        accessTokenGetter != null) {
      // Dodajemy interceptor wstrzykujący token
      dio.interceptors.add(
        _createAuthInterceptor(storage, accessTokenGetter, logger),
      );

      // Dodajemy interceptor odświeżania (jeśli podano wymagane serwisy)
      if (sessionService != null && refreshClient != null) {
        dio.interceptors.add(
          TokenRefreshInterceptor(
            dio,
            storage,
            logger,
            sessionService,
            refreshClient,
            onRefreshFailure,
          ),
        );
      }
    }

    return dio;
  }

  static String _getFingerprint(List<int> der) {
    final digest = sha256.convert(der);
    return digest.toString().toUpperCase();
  }

  static Interceptor _createAuthInterceptor(
    SecureStorageService storage,
    String? Function() accessTokenGetter,
    AppLogger logger,
  ) {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 1. Pobranie z RAM (AuthController) przez bezpieczny callback
        String? token = accessTokenGetter();

        if (token != null && token.isNotEmpty) {
          logger.i('🔑 Auth: Token from RAM');
        } else {
          // 2. Fallback do dysku (SecureStorage)
          token = await storage.read(key: StorageKeys.accessToken);
          if (token != null && token.isNotEmpty) {
            logger.i('📦 Auth: Token from Disk');
          } else {
            logger.w('⚠️ Auth: No token found for ${options.path}');
          }
        }

        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        handler.next(options);
      },
    );
  }
}
