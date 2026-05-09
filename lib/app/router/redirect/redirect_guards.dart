// lib/app/router/redirect_guards.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';

String? rootGuard(Ref ref, GoRouterState state) {
  final logger = ref.read(appLoggerProvider);
  final authState = ref.read(authControllerProvider);
  final securityState = ref.read(securityServiceProvider);
  final path = state.uri.path;

  final isPinScreen = path == AppRoutes.pin;
  final isLoginScreen = path == AppRoutes.login;
  final is2FaScreen = path == AppRoutes.twoFaVerify;
  final isSetupScreen = path == AppRoutes.securitySetup;

  final publicRoutes = [AppRoutes.login, AppRoutes.resetPassword];

  logger.i('[ RedirectGuard ] authState: $authState');

  // LOCK SCREEN (PIN)
  if (securityState.shouldShowLock) {
    if (path != AppRoutes.pin) {
      logger.i('[ RedirectGuard ]: App locked, forcing PIN screen');
      return AppRoutes.pin;
    }
    return null;
  }

  // LOADING / INITIAL
  if (authState.isLoading || authState.isInitial) return null;

  // UNATHENTICATED
  if (authState.isUnauthenticated) {
    if (!publicRoutes.contains(path)) {
      logger.w(
        '[ RedirectGuard ]: Unauthorized access to $path -> Redirect to Login',
      );
      return AppRoutes.login;
    }
    return null;
  }

  // KROKI POŚREDNIE (2FA / Setup)
  if (authState.isTwoFaRequired) {
    if (path != AppRoutes.twoFaVerify) {
      logger.i('[ RedirectGuard ]: 2FA required');
      return AppRoutes.twoFaVerify;
    }
    return null;
  }

  if (authState.isPartiallyAuthenticated || !securityState.isSetupCompleted) {
    if (path != AppRoutes.securitySetup) {
      logger.i('[ RedirectGuard ]: Security setup incomplete');
      return AppRoutes.securitySetup;
    }
    return null;
  }
  //  ZALOGOWANY
  if (authState.isAuthenticated) {
    final isAtAuthFlow =
        isLoginScreen || is2FaScreen || isPinScreen || isSetupScreen;
    if (isAtAuthFlow) {
      logger.i(
        '[ RedirectGuard ]: User authenticated, redirecting from auth flow to Home',
      );
      return AppRoutes.home;
    }
  }

  return null;
}
