import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
// import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';

String? rootGuard(Ref ref, GoRouterState state) {
  // final logger = ref.read(appLoggerProvider);
  final authState = ref.read(authControllerProvider);
  final securityState = ref.read(securityServiceProvider);
  final path = state.uri.path;

  final isInitialScreen = path == AppRoutes.initial;
  final isPinScreen = path == AppRoutes.pin;
  final isLoginScreen = path == AppRoutes.login;
  final is2FaScreen = path == AppRoutes.twoFaVerify;
  final isSetupScreen = path == AppRoutes.securitySetup;

  final publicRoutes = [AppRoutes.login, AppRoutes.resetPassword];

  // 1. DOKĄD SECURITY NIE JEST GOTOWE LUB AUTH JEST W TRAKCIE STARTU -> TRZYMAMY NA /initial
  if (!securityState.initialized ||
      authState.isLoading ||
      authState.isInitial) {
    if (!isInitialScreen) {
      return AppRoutes.initial;
    }
    return null;
  }

  // 2. LOCK SCREEN (PIN)
  if (securityState.shouldShowLock) {
    if (!isPinScreen) {
      // logger.i('[ RedirectGuard ]: App locked, forcing PIN screen');
      return AppRoutes.pin;
    }
    return null;
  }

  // 3. UNAUTHENTICATED (Czysty storage / brak sesji)
  if (authState.isUnauthenticated) {
    if (!publicRoutes.contains(path)) {
      // logger.w(
      //   '[ RedirectGuard ]: Unauthorized access to $path -> Redirect to Login',
      // );
      return AppRoutes.login;
    }
    return null;
  }

  // 4. KROKI POŚREDNIE (2FA / Setup)
  if (authState.isTwoFaRequired) {
    if (!is2FaScreen) {
      // logger.i('[ RedirectGuard ]: 2FA required');
      return AppRoutes.twoFaVerify;
    }
    return null;
  }

  if (authState.isPartiallyAuthenticated) {
    if (!securityState.isSetupCompleted) {
      if (!isSetupScreen) {
        return AppRoutes.securitySetup;
      }
      return null;
    }

    return AppRoutes.home;
  }

  // 5. ZALOGOWANY
  if (authState.isAuthenticated) {
    final isAtAuthFlow =
        isInitialScreen ||
        isLoginScreen ||
        is2FaScreen ||
        isPinScreen ||
        isSetupScreen;

    if (isAtAuthFlow) {
      // logger.i(
      //   '[ RedirectGuard ]: User authenticated, redirecting from auth flow to Home',
      // );
      return AppRoutes.home;
    }
  }

  return null;
}
