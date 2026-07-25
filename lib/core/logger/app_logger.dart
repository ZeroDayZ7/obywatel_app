import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:obywatel_plus/core/logger/models/log_models.dart';

class AppLogger {
  final Queue<Breadcrumb> _breadcrumbs = Queue();
  final int _maxBreadcrumbs = 20;
  final Logger _logger;

  AppLogger()
    : _logger = Logger(
        filter: ProductionFilter(),
        level: kReleaseMode ? Level.warning : Level.debug,
        printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 3,
          lineLength: 80,
          colors: true,
          printEmojis: false,
          noBoxingByDefault: true,
        ),
      );

  // Publiczne API loggera
  void t(String message, {String? module}) =>
      _log(LogLevel.trace, message, module: module);
  void d(String message, {String? module}) =>
      _log(LogLevel.debug, message, module: module);
  void i(String message, {String? module}) =>
      _log(LogLevel.info, message, module: module);

  void w(
    String message, {
    String? module,
    dynamic error,
    StackTrace? stackTrace,
  }) => _log(
    LogLevel.warning,
    message,
    module: module,
    error: error,
    stackTrace: stackTrace,
  );

  void e(
    String message, {
    String? module,
    dynamic error,
    StackTrace? stackTrace,
  }) => _log(
    LogLevel.error,
    message,
    module: module,
    error: error,
    stackTrace: stackTrace,
  );

  void _log(
    LogLevel level,
    String message, {
    String? module,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final formattedMessage = _format(message, module);

    _logger.log(
      _mapLevel(level),
      formattedMessage,
      error: error,
      stackTrace: stackTrace,
    );

    _addBreadcrumb(message, level, module);

    if (kReleaseMode &&
        (level == LogLevel.error || level == LogLevel.warning)) {
      _sendToPrivateApi(
        level: level,
        message: formattedMessage,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  void _addBreadcrumb(String message, LogLevel level, String? module) {
    if (_breadcrumbs.length >= _maxBreadcrumbs) {
      _breadcrumbs.removeFirst();
    }

    _breadcrumbs.add(
      Breadcrumb(
        timestamp: DateTime.now().toIso8601String(),
        message: message,
        level: level,
        module: module ?? 'app',
      ),
    );
  }

  Future<void> _sendToPrivateApi({
    required LogLevel level,
    required String message,
    dynamic error,
    StackTrace? stackTrace,
  }) async {
    try {
      final payload = LogPayload(
        level: level,
        message: message,
        env: kReleaseMode ? 'production' : 'development',
        error: error?.toString(),
        stackTrace: stackTrace?.toString(),
        breadcrumbs: _breadcrumbs.toList(),
      );

      if (kDebugMode) {
        _logger.d('[API] Telemetry payload ready: ${payload.toJson()}');
      }

      // TODO: _apiClient.post('/logs', data: payload.toJson());
    } catch (e, st) {
      // Używamy _logger bezpośrednio z pominięciem _log(),
      // aby zapobiec zapętleniu (tzw. stack overflow) w przypadku awarii sieci/parsera
      _logger.log(
        Level.error,
        '[Logger] Critical failure inside _sendToPrivateApi',
        error: e,
        stackTrace: st,
      );
    }
  }

  String _format(String message, String? module) =>
      module != null ? '[$module] $message' : message;

  Level _mapLevel(LogLevel level) => switch (level) {
    LogLevel.trace => Level.trace,
    LogLevel.debug => Level.debug,
    LogLevel.info => Level.info,
    LogLevel.warning => Level.warning,
    LogLevel.error => Level.error,
  };
}
