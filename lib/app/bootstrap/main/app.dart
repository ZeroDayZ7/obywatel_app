// lib/app/app.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/main/app_bootstrap_handler.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/app/router/app_router_provider.dart';
import 'package:obywatel_plus/app/theme/app_theme.dart';
import 'package:obywatel_plus/app/theme/theme_notifier.dart';

class ObywatelPlusApp extends ConsumerWidget {
  const ObywatelPlusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: apiConstants.appName,
      debugShowCheckedModeBanner: false,

      // Konfiguracja motywu
      theme: AppTheme.buildTheme(Brightness.light),
      darkTheme: AppTheme.buildTheme(Brightness.dark),
      themeMode: themeMode,

      // Konfiguracja języka
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,

      // Konfiguracja nawigacji
      routerConfig: router,

      // DEKOMPOZYCJA: Logika wyboru ekranu (Splash/Error/App)
      // ląduje w dedykowanym Handlerze
      builder: (context, child) {
        return AppBootstrapHandler(child: child!);
      },
    );
  }
}
