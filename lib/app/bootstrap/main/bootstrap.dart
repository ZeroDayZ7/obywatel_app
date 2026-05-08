import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/main/app_observer.dart';
import 'package:obywatel_plus/app/lang/lang_config.dart';
import 'package:obywatel_plus/core/errors/presentation/global_error_screen.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _logger = AppLogger();

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = _handleFlutterError;

  PlatformDispatcher.instance.onError = (error, stack) {
    _handleGlobalError(error, stack);
    return true;
  };

  ErrorWidget.builder = (FlutterErrorDetails details) {
    if (kDebugMode) {
      return ErrorWidget(details.exception);
    }
    return GlobalErrorScreen(error: details.exception);
  };

  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();

    final prefsInstance = await SharedPreferences.getInstance();
    final sharedService = SharedPreferencesService(prefsInstance, _logger);
    final observer = AppObserver(_logger);

    runApp(
      EasyLocalization(
        supportedLocales: LangConfig.supportedLocales,
        path: LangConfig.translationsPath,
        fallbackLocale: LangConfig.fallbackLocale,
        saveLocale: true,
        useOnlyLangCode: true,
        child: ProviderScope(
          overrides: [
            activePrefsProvider.overrideWithValue(sharedService),
            appLoggerProvider.overrideWithValue(_logger),
          ],
          observers: [observer],
          // observers: kDebugMode ? [observer] : [],
          child: await builder(),
        ),
      ),
    );
  }, (error, stack) => _handleGlobalError(error, stack));
}

void _handleGlobalError(Object error, StackTrace stack) {
  _logger.e(
    '🔥 Global Error',
    error: error,
    stackTrace: stack,
    module: 'Bootstrap',
  );
}

void _handleFlutterError(FlutterErrorDetails details) {
  _logger.e(
    '💥 Flutter Error',
    error: details.exception,
    stackTrace: details.stack,
    module: 'Bootstrap',
  );
}
