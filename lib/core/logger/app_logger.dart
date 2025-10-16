import 'package:logger/logger.dart';

class AppLogger {
  final Logger _logger;

  AppLogger()
    : _logger = Logger(
        printer: PrettyPrinter(
          methodCount: 2,
          errorMethodCount: 5,
          lineLength: 80,
          colors: true,
          printEmojis: true,
        ),
      );

  void d(
    String message, {
    String? module,
    dynamic error,
    StackTrace? stackTrace,
  }) => _logger.d(
    _formatMessage(message, module),
    error: error,
    stackTrace: stackTrace,
  );

  void i(
    String message, {
    String? module,
    dynamic error,
    StackTrace? stackTrace,
  }) => _logger.i(
    _formatMessage(message, module),
    error: error,
    stackTrace: stackTrace,
  );

  void w(
    String message, {
    String? module,
    dynamic error,
    StackTrace? stackTrace,
  }) => _logger.w(
    _formatMessage(message, module),
    error: error,
    stackTrace: stackTrace,
  );

  void e(
    String message, {
    String? module,
    dynamic error,
    StackTrace? stackTrace,
  }) => _logger.e(
    _formatMessage(message, module),
    error: error,
    stackTrace: stackTrace,
  );

  String _formatMessage(String message, String? module) {
    return module != null ? "[$module] $message" : message;
  }
}
