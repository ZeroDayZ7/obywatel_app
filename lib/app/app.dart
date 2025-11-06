// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/core/errors/error_boundary.dart'
    show ErrorBoundary;
import 'theme/app_theme.dart';
import 'theme/theme_notifier.dart';
import 'router/app_router_provider.dart';

class ObywatelPlusApp extends ConsumerWidget {
  const ObywatelPlusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: apiConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      locale: const Locale('pl', 'PL'),
      builder: (context, child) {
        return ErrorBoundary(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
