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

enum DioProfile { public, authenticated, refreshToken, noAuthAuth }

class DioFactory {
  static Dio create({
    required DioProfile profile,
    required AppLogger logger,
    Ref? deviceInfoRef,
  }) {
    // 1. Wybór BaseUrl (zostaje bez zmian)
    final String baseUrl = switch (profile) {
      DioProfile.public => ServicesConfig.versionBaseUrl,
      _ => ServicesConfig.authBaseUrl,
    };

    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(seconds: apiConstants.connectTimeoutSeconds),
        receiveTimeout: Duration(seconds: apiConstants.receiveTimeoutSeconds),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // 2. SSL PINNING (zostaje bez zmian - to Twoja polisa ubezpieczeniowa)
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

    // 3. INTERCEPTORY GLOBALNE
    dio.interceptors.addAll([
      if (deviceInfoRef != null) DeviceInterceptor(deviceInfoRef),
      LoggingInterceptor(logger: logger),
      GlobalErrorInterceptor(logger: logger),
    ]);

    // UWAGA: Nie dodajemy tutaj interceptorów autoryzacji!
    // One zostaną dodane w providers.dart przy użyciu Fresh.

    return dio;
  }

  static String _getFingerprint(List<int> der) {
    final digest = sha256.convert(der);
    return digest.toString().toUpperCase();
  }
}
