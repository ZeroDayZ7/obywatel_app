import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/app_root.dart';
import 'package:obywatel_plus/app/bootstrap/app_observer.dart';

void main() async {
  BindingBase.debugZoneErrorsAreFatal = true;

  /// Główna strefa bezpieczeństwa
  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      final observer = AppObserver();
      runApp(
        ProviderScope(
          observers: kDebugMode ? [observer] : [],
          child: const AppRoot(),
        ),
      );
    },
    (error, stack) {
      _handleGlobalError(error, stack);
    },
  );

  /// Błędy frameworka (build, render, widgety)
  FlutterError.onError = _handleFlutterError;

  /// Błędy systemowe i spoza zony (np. z isolate)
  PlatformDispatcher.instance.onError = (error, stack) {
    _handleGlobalError(error, stack);
    return true;
  };
}

/// Obsługa błędów globalnych
void _handleGlobalError(Object error, StackTrace stack) {
  final type = error.runtimeType;
  if (kDebugMode) {
    debugPrint('🔥 [GlobalError][$type] $error');
    debugPrintStack(stackTrace: stack);
  } else {
    // ignore: todo
    // TODO: Wysyłanie do Sentry / Crashlytics w trybie produkcyjnym
  }
}

/// Obsługa błędów frameworka
void _handleFlutterError(FlutterErrorDetails details) {
  if (kDebugMode) {
    print('💥 [FlutterError] ${details.exceptionAsString()}');
    debugPrintStack(stackTrace: details.stack);
  } else {
    // ignore: todo
    // TODO: Raportowanie do zewnętrznego systemu w trybie produkcyjnym
  }
}
