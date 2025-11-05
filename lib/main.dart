import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/app_root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded<Future<void>>(
    () async {
      runApp(const ProviderScope(child: AppRoot()));
    },
    (error, stack) {
      _handleGlobalError(error, stack);
    },
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    _handleFlutterError(details);
  };
}

/// Obsługa błędów globalnych
void _handleGlobalError(Object error, StackTrace stack) {
  if (kDebugMode) {
    print('🔥 [GlobalError] $error');
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
