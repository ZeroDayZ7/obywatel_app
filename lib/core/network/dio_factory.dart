import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // DODANE: dla klasy Ref
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/app/config/services_config.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/device_interceptor.dart';
import 'package:obywatel_plus/core/network/global_error_interceptor.dart';
import 'package:obywatel_plus/core/network/logging_interceptor.dart';
import 'package:obywatel_plus/core/network/token_refresh_interceptor.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';

enum DioProfile { public, authenticated, refreshToken, noAuthAuth }

class DioFactory {
  static Dio create({
    required DioProfile profile,
    required AppLogger logger,
    required Ref ref, // Wymagane do sprawdzania RAMu
    SecureStorageService? storage,
    SessionService? sessionService,
    Dio? refreshClient,
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

    // Interceptory globalne
    dio.interceptors.addAll([
      DeviceInterceptor(ref),
      LoggingInterceptor(logger: logger),
      GlobalErrorInterceptor(logger: logger),
    ]);

    // Interceptory autoryzacji
    if (profile == DioProfile.authenticated &&
        storage != null &&
        sessionService != null &&
        refreshClient != null) {
      dio.interceptors.add(_createAuthInterceptor(storage, ref, logger));
      dio.interceptors.add(
        TokenRefreshInterceptor(
          dio,
          storage,
          logger,
          sessionService,
          refreshClient,
          ref,
        ),
      );
    }

    return dio;
  }

  /// Naprawiona metoda pobierająca fingerprint
  static String _getFingerprint(List<int> der) {
    final digest = sha256.convert(der);
    return digest.toString().toUpperCase();
  }

  /// Interceptor z logiką: Dysk -> RAM (dla bezpieczeństwa podczas setupu)
  static Interceptor _createAuthInterceptor(
    SecureStorageService storage,
    Ref ref,
    AppLogger logger,
  ) {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // 1. Próba pobrania z RAMu
        String? token = ref
            .read(authControllerProvider)
            .mapOrNull(authenticated: (s) => s.accessToken);

        if (token != null && token.isNotEmpty) {
          logger.i(
            '🔑 AuthInterceptor: Token retrieved from RAM (AuthController)',
          );
        } else {
          // 2. Próba pobrania z dysku (jeśli w RAM pusto)
          token = await storage.read(key: StorageKeys.accessToken);
          if (token != null && token.isNotEmpty) {
            logger.i(
              '📦 AuthInterceptor: Token retrieved from Disk (SecureStorage)',
            );
          } else {
            logger.w(
              '⚠️ AuthInterceptor: No token found in RAM or Disk for path: ${options.path}',
            );
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
