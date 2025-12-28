// lib/app/app.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/app_init_provider.dart';
import 'package:obywatel_plus/app/bootstrap/app_init_status.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/error_app.dart';
// import 'package:obywatel_plus/app/bootstrap/presentation/force_update_screen.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/splash_screen.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/core/errors/global_error_listener.dart';

import 'router/app_router_provider.dart';
import 'theme/app_theme.dart';
import 'theme/theme_notifier.dart';

class ObywatelPlusApp extends ConsumerWidget {
  const ObywatelPlusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(appRouterProvider);
    final status = ref.watch(appInitProvider);

    return MaterialApp.router(
      title: apiConstants.appName,
      debugShowCheckedModeBanner: false,

      theme: AppTheme.buildTheme(Brightness.light),
      darkTheme: AppTheme.buildTheme(Brightness.dark),
      themeMode: themeMode,

      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,

      routerConfig: router,

      builder: (context, child) {
        final app = GlobalErrorListener(child: child!);
        return status.when(
          loading: () => const SplashScreen(),

          blocked: (reason) => ErrorApp(error: reason ?? 'unknown_error'),

          forceUpdate: () => const SplashScreen(),
          // forceUpdate: () => const ForceUpdateScreen(),
          unauthenticated: () => app,
          lockedPin: () => app,
          authorized: () => app,
        );
      },
    );
  }
}
