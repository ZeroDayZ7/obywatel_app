// lib/app/app.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/main/app_bootstrap_handler.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/privacy_overlay.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/app/lang/lang_config.dart';
import 'package:obywatel_plus/app/router/app_router_provider.dart';
import 'package:obywatel_plus/app/theme/app_theme.dart';
import 'package:obywatel_plus/app/theme/theme_notifier.dart';
import 'package:obywatel_plus/core/errors/global_notification_overlay.dart';
import 'package:obywatel_plus/core/security/lifecycle/app_lifecycle_observer_provider.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/features/auth/application/session/session_observer.dart';
import 'package:secure_application/secure_application.dart';

class ObywatelPlusApp extends ConsumerWidget {
  const ObywatelPlusApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(appRouterProvider);
    ref.watch(appLifecycleObserverProvider);

    return SecureApplication(
      nativeRemoveDelay: 100,
      onNeedUnlock: (controller) {
        ref
            .read(securityServiceProvider.notifier)
            .registerSecureController(controller);
        return null;
      },
      child: Builder(
        builder: (context) {
          return MaterialApp.router(
            title: apiConstants.appName,
            debugShowCheckedModeBanner: false,

            // Konfiguracja motywu
            theme: AppTheme.buildTheme(Brightness.light),
            darkTheme: AppTheme.buildTheme(Brightness.dark),
            themeMode: themeMode,

            // Konfiguracja języka
            locale: context.locale,
            supportedLocales: LangConfig.supportedLocales,
            localizationsDelegates: context.localizationDelegates,

            // Konfiguracja nawigacji
            routerConfig: router,
            builder: (context, child) {
              return GlobalNotificationOverlay(
                child: AppBootstrapHandler(
                  child: SecureGate(
                    blurr: 20,
                    opacity: 0.8,
                    lockedBuilder: (context, controller) =>
                        PrivacyOverlay(controller: controller!),
                    // 1. Owiń bezpośrednio wewnętrzny 'child' routera w Listener:
                    child: Listener(
                      behavior: HitTestBehavior.translucent,
                      onPointerDown: (_) {
                        ref
                            .read(sessionObserverProvider.notifier)
                            .onUserInteraction();
                      },
                      child: child!,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
