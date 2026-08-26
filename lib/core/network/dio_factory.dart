import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/app/config/services_config.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/clients/device_fingerprint_interceptor.dart';
import 'package:obywatel_plus/core/network/interceptors/global_error_interceptor.dart';
import 'package:obywatel_plus/core/network/interceptors/logging_interceptor.dart';

enum DioProfile { public, authenticated, refreshToken, noAuthAuth }

Dio createDioInstance({
  required DioProfile profile,
  required AppLogger logger,
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

  if (!kIsWeb && apiConstants.enableSSLPinning) {
    final allowedFingerprints = (apiConstants.apiFingerprints)
        .map((fp) => fp.replaceAll(':', '').toUpperCase())
        .toList();

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () => HttpClient(),
      validateCertificate: (cert, host, port) {
        if (cert == null) return false;

        final serverFingerprint = _calculateSha256Fingerprint(cert.der);
        final bool isValid = allowedFingerprints.contains(serverFingerprint);

        if (!isValid) {
          logger.e(
            '🚨 SSL Pinning Violation! Host: $host | Received: $serverFingerprint',
          );
        }
        return isValid;
      },
    );
  }

  dio.interceptors.addAll([
    LoggingInterceptor(logger: logger),
    GlobalErrorInterceptor(logger: logger),
  ]);

  if (deviceInfoRef != null) {
    dio.interceptors.add(DeviceFingerprintInterceptor(deviceInfoRef));
  }

  return dio;
}

String _calculateSha256Fingerprint(List<int> der) {
  final digest = sha256.convert(der);
  return digest.toString().toUpperCase();
}