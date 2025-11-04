// lib/app/router/redirect_logic.dart
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/core/core_providers.dart';

String? appRedirectLogic(Ref ref, GoRouterState state) {
  final logger = ref.read(appLoggerProvider);
  final securityState = ref.watch(securityServiceProvider);

  final path = state.uri.path;
  final isLoggedIn = securityState.hasSession;
  final shouldShowLock = securityState.shouldShowLock;
  final skipSetup = securityState.skipSetup;
  final initialized = securityState.initialized;

  final goingToLogin = path == AppRoutes.login;
  final goingToPin = path == AppRoutes.pin;
  final goingToSetup = path == AppRoutes.securitySetup;

  if (!initialized) {
    logger.w('⏳ SecurityService nie zainicjalizowany — brak redirectu');
    return null;
  }

  String? redirect;

  if (!isLoggedIn && !goingToLogin) {
    redirect = AppRoutes.login;
    logger.i('🚫 Redirect do login, użytkownik niezalogowany');
  } else if (isLoggedIn && !shouldShowLock && !skipSetup && !goingToSetup) {
    redirect = AppRoutes.securitySetup;
    logger.i('🔐 Redirect do Security Setup — brak ustawionego PIN/biometrii');
  } else if (isLoggedIn && shouldShowLock && !goingToPin) {
    redirect = AppRoutes.pin;
    logger.i('🔒 Redirect do ekranu PIN — wymagana blokada');
  } else if (isLoggedIn && goingToLogin) {
    redirect = AppRoutes.home;
    logger.i(
      '🏠 Zalogowany użytkownik próbuje wejść na login — redirect do home',
    );
  }

  if (redirect == null) {
    logger.d('✅ Brak potrzeby redirectu — zostajemy na $path');
  }

  return redirect;
}
