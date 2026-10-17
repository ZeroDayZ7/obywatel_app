import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';

class DeviceFingerprintInterceptor extends Interceptor {
  final Ref ref;

  DeviceFingerprintInterceptor(this.ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Pobieramy serwis przez ref (riverpod)
      final deviceInfoService = ref.read(deviceInfoServiceProvider);
      final fingerprint = await deviceInfoService.getFingerprint();

      final normalizedFingerprint = fingerprint.trim();
      if (normalizedFingerprint.isNotEmpty) {
        options.headers[StorageKeys.headerFingerPrint] = normalizedFingerprint;
      }
    } catch (e) {
      // Jeśli pobranie fingerprintu zawiedzie, logujemy to, ale puszczamy request
      // (Serwer i tak go odrzuci, jeśli jest wymagany)
    }

    super.onRequest(options, handler);
  }
}
