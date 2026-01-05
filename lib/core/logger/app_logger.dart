import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  final Logger _logger;

  AppLogger()
    : _logger = Logger(
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

  void d(
    String message, {
    String? module,
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      _logger.d(_format(message, module), error: error, stackTrace: stackTrace);

  void i(
    String message, {
    String? module,
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      _logger.i(_format(message, module), error: error, stackTrace: stackTrace);

  void w(
    String message, {
    String? module,
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      _logger.w(_format(message, module), error: error, stackTrace: stackTrace);

  void e(
    String message, {
    String? module,
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      _logger.e(_format(message, module), error: error, stackTrace: stackTrace);

  void t(
    String message, {
    String? module,
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      _logger.t(_format(message, module), error: error, stackTrace: stackTrace);

  String _format(String message, String? module) =>
      module != null ? '[$module] $message' : message;
}
