// lib/app/router/redirect_guards.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';

String? rootGuard(Ref ref, GoRouterState state) {
  final authState = ref.read(authControllerProvider);
  final securityState = ref.read(securityServiceProvider);
  final path = state.uri.path;

  final isPinScreen = path == AppRoutes.pin;
  final isLoginScreen = path == AppRoutes.login;
  final is2FaScreen = path == AppRoutes.twoFaVerify;
  final isSetupScreen = path == AppRoutes.securitySetup;

  final publicRoutes = [AppRoutes.login, AppRoutes.resetPassword];

  // LOCK SCREEN (PIN)
  if (securityState.shouldShowLock) {
    return isPinScreen ? null : AppRoutes.pin;
  }

  // LOADING / INITIAL
  if (authState.isLoading || authState.isInitial) return null;

  // UNATHENTICATED
  if (authState.isUnauthenticated) {
    return publicRoutes.contains(path) ? null : AppRoutes.login;
  }

  //  KROKI POŚREDNIE (2FA / Setup)
  if (authState.isTwoFaRequired) {
    return is2FaScreen ? null : AppRoutes.twoFaVerify;
  }

  if (authState.isPartiallyAuthenticated || !securityState.isSetupCompleted) {
    return isSetupScreen ? null : AppRoutes.securitySetup;
  }

  //  ZALOGOWANY
  if (authState.isAuthenticated) {
    final isAtAuthFlow =
        isLoginScreen || is2FaScreen || isPinScreen || isSetupScreen;
    if (isAtAuthFlow) return AppRoutes.home;
  }

  return null;
}
