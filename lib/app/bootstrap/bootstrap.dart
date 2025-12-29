import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/app_observer.dart';

/// Funkcja inicjalizująca całą infrastrukturę aplikacji przed jej uruchomieniem.
Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  // 1️⃣ Konfiguracja błędów frameworka Flutter
  FlutterError.onError = _handleFlutterError;

  // 2️⃣ Błędy spoza głównego isolate
  PlatformDispatcher.instance.onError = (error, stack) {
    _handleGlobalError(error, stack);
    return true;
  };

  // 3️⃣ Konfiguracja ErrorWidget (UI dla błędów w trybie debug/prod)
  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (kDebugMode) {
      return ErrorWidget(details.exception);
    }
    return const Scaffold(
      body: Center(
        child: Text('Coś poszło nie tak 🧱', style: TextStyle(fontSize: 16)),
      ),
    );
  };

  // 4️⃣ Uruchomienie w strefie bezpieczeństwa (async errors)
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();

    final observer = AppObserver();

    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('pl'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: const Locale('pl'),
        saveLocale: true,
        useOnlyLangCode: true,
        child: ProviderScope(
          observers: kDebugMode ? [observer] : [],
          child: await builder(),
        ),
      ),
    );
  }, (error, stack) => _handleGlobalError(error, stack));
}

void _handleGlobalError(Object error, StackTrace stack) {
  if (kDebugMode) {
    debugPrint('🔥 [GlobalError][${error.runtimeType}] $error');
    debugPrintStack(stackTrace: stack);
  } else {
    // TOD: Sentry / Crashlytics
  }
}

void _handleFlutterError(FlutterErrorDetails details) {
  if (kDebugMode) {
    debugPrint('💥 [FlutterError] ${details.exceptionAsString()}');
    debugPrintStack(stackTrace: details.stack);
  } else {
    // TOD: Raportowanie do zewnętrznego systemu
  }
}
