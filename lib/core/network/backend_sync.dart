import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_root_jailbreak_checker/flutter_root_jailbreak_checker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/auth/application/session/session_status_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'backend_sync.freezed.dart';
part 'backend_sync.g.dart';

@freezed
sealed class BackendState with _$BackendState {
  const factory BackendState({
    DateTime? serverTime,
    @Default(Duration.zero) Duration timeOffset,
    @Default(100) int rateLimitRemaining,
    String? lastRequestId,
    @Default(false) bool isMaintenanceMode,
    @Default(false) bool isDeviceSecure,
    String? deviceFingerprint,
  }) = _BackendState;

  const BackendState._();
  DateTime get currentCorrectedTime => DateTime.now().add(timeOffset);
}

@Riverpod(keepAlive: true)
class BackendStateNotifier extends _$BackendStateNotifier {
  static const _timeKey = 'last_sync_server_time';
  static const _offsetKey = 'last_sync_time_offset';

  @override
  FutureOr<BackendState> build() async {
    final storage = ref.watch(secureStorageProvider);
    final deviceInfo = ref.watch(deviceInfoServiceProvider);

    final results = await Future.wait([
      storage.read(key: _timeKey),
      storage.read(key: _offsetKey),
      deviceInfo.getFingerprint(),
    ]);

    final savedTime = results[0];
    final savedOffsetMs = results[1];
    final fingerprint = results[2];

    return BackendState(
      serverTime: savedTime != null ? DateTime.tryParse(savedTime) : null,
      timeOffset: Duration(
        milliseconds: int.tryParse(savedOffsetMs ?? '0') ?? 0,
      ),
      isDeviceSecure: true,
      deviceFingerprint: fingerprint,
    );
  }

  DateTime getSafeNow() {
    final current = state.value;
    if (current == null) return DateTime.now();
    return current.currentCorrectedTime;
  }

  void updateFromHeaders({
    DateTime? serverTime,
    int? rateLimit,
    String? requestId,
  }) {
    update((s) {
      Duration newOffset = s.timeOffset;
      if (serverTime != null) {
        final calculatedOffset = serverTime.difference(DateTime.now());
        if (s.serverTime == null ||
            (calculatedOffset - s.timeOffset).abs().inSeconds > 1) {
          newOffset = calculatedOffset;
        }
      }

      return s.copyWith(
        serverTime: serverTime ?? s.serverTime,
        timeOffset: newOffset,
        rateLimitRemaining: rateLimit ?? s.rateLimitRemaining,
        lastRequestId: requestId ?? s.lastRequestId,
      );
    });

    if (rateLimit != null && rateLimit < 10) {
      ref
          .read(appLoggerProvider)
          .w(
            'Critical Rate Limit: $rateLimit requests remaining',
            module: 'BACKEND',
          );
    }
  }

  void setDeviceSecurity(bool isSecure) {
    update((s) {
      if (s.isDeviceSecure == isSecure) return s;

      final log = ref.read(appLoggerProvider);
      if (isSecure) {
        log.i('Device security check: PASSED', module: 'SECURITY');
      } else {
        log.e(
          'Device security check: FAILED (Potential threat)',
          module: 'SECURITY',
        );
      }

      return s.copyWith(isDeviceSecure: isSecure);
    });
  }

  Future<void> persistServerTime() async {
    final currentState = state.value;
    if (currentState == null || currentState.serverTime == null) return;

    try {
      final storage = ref.read(secureStorageProvider);

      await storage.write(
        key: _timeKey,
        value: currentState.serverTime!.toIso8601String(),
      );

      await storage.write(
        key: _offsetKey,
        value: currentState.timeOffset.inMilliseconds.toString(),
      );

      ref
          .read(appLoggerProvider)
          .d(
            '💾 Persisted time & offset (${currentState.timeOffset.inMilliseconds}ms)',
            module: 'BACKEND',
          );
    } catch (e) {
      ref
          .read(appLoggerProvider)
          .e('Failed to persist time', module: 'BACKEND', error: e);
    }
  }
}

class SecuritySyncInterceptor extends Interceptor {
  final Ref ref;
  final _checker = FlutterRootJailbreakChecker();
  DateTime? _lastSecurityCheck;
  bool _cachedSecurityResult = true;

  SecuritySyncInterceptor(this.ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final now = DateTime.now();
    final log = ref.read(appLoggerProvider);
    final backendState = ref.read(backendStateProvider).value;

    if (backendState?.deviceFingerprint != null) {
      options.headers['X-Device-Fingerprint'] = backendState!.deviceFingerprint;
    }

    if (!Platform.isAndroid && !Platform.isIOS) {
      options.headers['X-Device-Secure'] = 'true';
      return super.onRequest(options, handler);
    }

    if (_lastSecurityCheck == null ||
        now.difference(_lastSecurityCheck!).inMinutes >= 1) {
      try {
        log.d('Checking device integrity...', module: 'SECURITY');
        final result = await _checker.checkOfflineIntegrity();
        _cachedSecurityResult = !result.isRooted && !result.isJailbroken;
        _lastSecurityCheck = now;

        ref
            .read(backendStateProvider.notifier)
            .setDeviceSecurity(_cachedSecurityResult);
      } catch (e, s) {
        log.e(
          'Integrity check failed',
          module: 'SECURITY',
          error: e,
          stackTrace: s,
        );
        _cachedSecurityResult = false;
      }
    }

    options.headers['X-Device-Secure'] = _cachedSecurityResult.toString();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final h = response.headers;
    final log = ref.read(appLoggerProvider);

    DateTime? sTime;
    final dateRaw = h.value('date');
    if (dateRaw != null) {
      try {
        sTime = HttpDate.parse(dateRaw);
      } catch (_) {}
    }

    final rateLimit = int.tryParse(h.value('x-ratelimit-remaining') ?? '');
    final requestId = h.value('x-request-id') ?? h.value('traceparent');

    log.t(
      'Response headers sync: ID=$requestId, Time=$sTime',
      module: 'NETWORK',
    );

    ref
        .read(backendStateProvider.notifier)
        .updateFromHeaders(
          serverTime: sTime,
          rateLimit: rateLimit,
          requestId: requestId,
        );

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final requestId = err.response?.headers.value('x-request-id');
    final statusCode = err.response?.statusCode;
    final path = err.requestOptions.path;
    final log = ref.read(appLoggerProvider);

    log.e(
      'API Error: $path',
      module: 'NETWORK',
      error: 'ID: $requestId | ${err.message}',
    );

    final isAuthPath =
        path.contains('login') ||
        path.contains('register') ||
        path.contains('password-reset');

    if (statusCode == 401 && !isAuthPath) {
      log.w(
        '🔑 Session invalid on protected path ($path). Triggering force logout...',
        module: 'SECURITY',
      );

      ref.read(sessionStatusProvider.notifier).reportInvalidSession();
    }

    super.onError(err, handler);
  }
}
