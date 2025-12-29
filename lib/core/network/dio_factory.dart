import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/app/config/services_config.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/global_error_interceptor.dart';
import 'package:obywatel_plus/core/network/logging_interceptor.dart';
import 'package:obywatel_plus/core/network/token_refresh_interceptor.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';

enum DioProfile { public, authenticated, refreshToken, noAuthAuth }

class DioFactory {
  static Dio create({
    required DioProfile profile,
    required AppLogger logger,
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

    // --- SSL PINNING (Tylko dla platform mobilnych, Web tego nie wspiera) ---
    if (!kIsWeb && apiConstants.enableSSLPinning) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          // Opcjonalnie: tutaj można dodać obsługę proxy dla debugowania
          return client;
        },
        validateCertificate: (cert, host, port) {
          if (cert == null) return false;

          // Pobieramy odcisk palca z certyfikatu serwera
          final serverFingerprint = _getFingerprint(cert.der);

          // Porównujemy z hashem zapisanym w Env
          // Env.apiFingerprint powinien wyglądać np. tak: "A1B2C3D4..."
          final bool isValid = serverFingerprint == apiConstants.apiFingerprint;

          if (!isValid) {
            logger.e(
              '🚨 SSL Pinning Violation! Host: $host, Fingerprint: $serverFingerprint',
            );
          }

          return isValid;
        },
      );
    }

    // Interceptory
    dio.interceptors.addAll([
      LoggingInterceptor(logger: logger),
      GlobalErrorInterceptor(logger: logger),
    ]);

    if (profile == DioProfile.authenticated &&
        storage != null &&
        sessionService != null &&
        refreshClient != null) {
      dio.interceptors.add(_createAuthInterceptor(storage));
      dio.interceptors.add(
        TokenRefreshInterceptor(
          dio,
          storage,
          logger,
          sessionService,
          refreshClient,
        ),
      );
    }

    return dio;
  }

  /// Pomocnicza funkcja generująca hash SHA-256 z danych binarnych certyfikatu (DER)
  static String _getFingerprint(List<int> der) {
    final digest = sha256.convert(der);
    return digest.toString().toUpperCase();
  }

  static Interceptor _createAuthInterceptor(SecureStorageService storage) {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await storage.read(key: StorageKeys.accessToken);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
    );
  }
}
