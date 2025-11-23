import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/features/auth/application/auth/session_service.dart';

String? appRedirectLogic(Ref ref, GoRouterState state) {
  final logger = ref.read(appLoggerProvider);
  final securityState = ref.watch(securityServiceProvider);
  final authState = ref.watch(sessionServiceProvider);

  // Wartości do logowania
  final isLoggedIn = authState.isLoggedIn;
  final path = state.uri.path;
  final shouldShowLock = securityState.shouldShowLock;
  final skipSetup = securityState.skipSetup;
  final initialized = securityState.initialized;
  // final isSetupInProgress = securityState.isSetupInProgress;

  final goingToLogin = path == AppRoutes.login;
  final goingToPin = path == AppRoutes.pin;
  final goingToSetup = path == AppRoutes.securitySetup;

  logger.d(
    '📌 appRedirectLogic: path=$path, isLoggedIn=$isLoggedIn, '
    'shouldShowLock=$shouldShowLock, skipSetup=$skipSetup, initialized=$initialized, '
    'goingToLogin=$goingToLogin, goingToPin=$goingToPin, goingToSetup=$goingToSetup',
  );

  if (!initialized) {
    logger.w('⏳ Security nie gotowy lub setup w toku — brak redirectu');
    return null;
  }

  String? redirect;

  if (!isLoggedIn && !goingToLogin) {
    redirect = AppRoutes.login;
    logger.i('🚫 Redirect do login');
  } else if (isLoggedIn && !skipSetup && !goingToSetup) {
    redirect = AppRoutes.securitySetup;
    logger.i('🔐 Redirect do Security Setup');
  } else if (isLoggedIn && shouldShowLock && !goingToPin) {
    redirect = AppRoutes.pin;
    logger.i('🔒 Redirect do PIN verification');
  } else if (isLoggedIn &&
      !shouldShowLock &&
      securityState.isUnlocked &&
      goingToPin) {
    Future.delayed(const Duration(milliseconds: 200));
    redirect = AppRoutes.home;
    logger.i('🏠 PIN odblokowany – redirect do home');
  } else if (isLoggedIn && goingToLogin) {
    redirect = AppRoutes.home;
    logger.i('🏠 Zalogowany na login — do home');
  }

  if (redirect == null) {
    logger.d('✅ Zostajemy na $path');
  } else {
    logger.d('➡️ Redirect: $redirect');
  }

  return redirect;
}
