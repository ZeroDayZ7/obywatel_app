import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';

class DeviceInterceptor extends Interceptor {
  final Ref _ref;

  DeviceInterceptor(this._ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final deviceInfo = _ref.read(deviceInfoServiceProvider);
    // 2. Generujemy fingerprint
    final fingerprint = await deviceInfo.getSecureFingerprint();

    // 3. Dodajemy nagłówek, którego wymaga Go Backend
    options.headers['X-Device-Fingerprint'] = fingerprint;

    handler.next(options);
  }
}
