// lib/app/router/redirect_logic.dart
// import 'package:obywatel_plus/features/auth/application/auth_provider.dart';
import 'package:obywatel_plus/core/security/security_provider.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/app/di/injector.dart';

String? appRedirectLogic(Ref ref, GoRouterState state) {
  final logger = sl<AppLogger>();
  // final auth = ref.read(authProvider);
  final securityService = ref.read(securityServiceProvider);

  final path = state.uri.path;
  // final isLoggedIn = auth.value?.isLoggedIn ?? false;
  final isLoggedIn = securityService.hasSession;
  final shouldShowLock = securityService.shouldShowLock;
  final skipSetup = securityService.skipSetup;

  final goingToLogin = path == AppRoutes.login;
  final goingToPin = path == AppRoutes.pin;
  final goingToSetup = path == AppRoutes.securitySetup;

  logger.d('🧭 RedirectLogic start: path=$path');
  // logger.d(
  //   '➡️ Stan: isLoggedIn=$isLoggedIn, shouldShowLock=$shouldShowLock, skipSetup=$skipSetup, '
  //   'initialized=${securityService.initialized}',
  // );

  if (!securityService.initialized) {
    logger.w('⏳ SecurityService jeszcze nie zainicjalizowany — brak redirectu');
    return null;
  }

  // 1️⃣ Nie zalogowany → login
  if (!isLoggedIn && !goingToLogin) {
    logger.i('🚫 Użytkownik niezalogowany, redirect do login');
    return AppRoutes.login;
  }

  // 2️⃣ Zalogowany, brak zabezpieczeń → przejdź do setupu tylko jeśli nie pominięto
  if (isLoggedIn && !shouldShowLock && !skipSetup && !goingToSetup) {
    logger.i('🔐 Brak zabezpieczeń, redirect do ekranu Security Setup');
    return AppRoutes.securitySetup;
  }

  // 3️⃣ Zalogowany i wymagana blokada → ekran PIN
  if (isLoggedIn && shouldShowLock && !goingToPin) {
    logger.i('🔒 Wymagana blokada, redirect do ekranu PIN');
    return AppRoutes.pin;
  }

  // 4️⃣ Zalogowany i próbuje wejść na login → home
  if (isLoggedIn && goingToLogin) {
    logger.i(
      '🏠 Zalogowany użytkownik próbuje wejść na login, redirect do home',
    );
    return AppRoutes.home;
  }

  logger.d('✅ Brak potrzeby redirectu — zostajemy na $path');
  return null;
}
