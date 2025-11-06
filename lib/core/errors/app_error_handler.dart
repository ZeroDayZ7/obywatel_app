// lib/core/errors/app_error_handler.dart
import 'package:flutter/foundation.dart';

/// Globalny handler do logowania błędów
/// i integracji z systemami zewnętrznymi (np. Sentry, Crashlytics)
class AppErrorHandler {
  static void report(Object error, StackTrace? stack) {
    if (kDebugMode) {
      debugPrint('💥 [AppError] $error');
      debugPrintStack(stackTrace: stack);
    }
    // ignore: todo
    // TODO: dodać integrację z Sentry / Crashlytics w production
  }
}
