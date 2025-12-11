import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/app_root.dart';
import 'package:obywatel_plus/app/bootstrap/app_observer.dart';

void main() async {
  /// 1️⃣ Konfiguracja globalnego wyświetlania błędów UI (ErrorWidget)
  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (kDebugMode) {
      // W debug mode pokazuj szczegóły błędu na ekranie
      return ErrorWidget(details.exception);
    }
    // W produkcji — estetyczny placeholder zamiast crasha
    return const Scaffold(
      body: Center(child: Text('Coś poszło nie tak 🧱', style: TextStyle(fontSize: 16))),
    );
  };

  /// 2️⃣ Konfiguracja błędów frameworka Flutter
  FlutterError.onError = _handleFlutterError;

  /// 3️⃣ Błędy spoza głównego isolate
  PlatformDispatcher.instance.onError = (error, stack) {
    _handleGlobalError(error, stack);
    return true;
  };

  /// 4️⃣ Uruchomienie w strefie bezpieczeństwa (catchuje async errors)
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();
    final observer = AppObserver();

    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('pl'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('pl'),
        child: ProviderScope(observers: kDebugMode ? [observer] : [], child: const AppRoot()),
      ),
    );
  }, (error, stack) => _handleGlobalError(error, stack));
}

/// 🔹 Globalna obsługa błędów runtime (np. async)
void _handleGlobalError(Object error, StackTrace stack) {
  final type = error.runtimeType;
  if (kDebugMode) {
    debugPrint('🔥 [GlobalError][$type] $error');
    debugPrintStack(stackTrace: stack);
  } else {
    // ignore: todo
    // TODO: wysyłanie do Sentry / Crashlytics / Logger
  }
}

/// 🔹 Obsługa błędów Flutter frameworka (build/render/widget)
void _handleFlutterError(FlutterErrorDetails details) {
  if (kDebugMode) {
    debugPrint('💥 [FlutterError] ${details.exceptionAsString()}');
    debugPrintStack(stackTrace: details.stack);
  } else {
    // ignore: todo
    // TODO: raportowanie do zewnętrznego systemu w produkcji
  }
}
