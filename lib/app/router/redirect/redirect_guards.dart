import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';

String? rootGuard(Ref ref, GoRouterState state) {
  final authState = ref.read(authControllerProvider);
  final securityState = ref.read(securityServiceProvider);
  final path = state.uri.path;

  final isInitialScreen = path == AppRoutes.initial;
  final isPinScreen = path == AppRoutes.pin;
  final isLoginScreen = path == AppRoutes.login;
  final is2FaScreen = path == AppRoutes.twoFaVerify;
  final isSetupScreen = path == AppRoutes.securitySetup;

  final publicRoutes = [AppRoutes.login, AppRoutes.resetPassword];

  // 0. Autentykacja w toku -> nie zmieniaj trasy
  if (authState.isLoading) {
    return null;
  }

  // 1. UNAUTHENTICATED
  if (authState.isUnauthenticated) {
    final isPublic = publicRoutes.contains(path);
    if (!isPublic) {
      return AppRoutes.login;
    }
    return null;
  }

  // 2. SPRAWDZENIE INICJALIZACJI
  final isAllowableWithoutSecurity = publicRoutes.contains(path) ||
      authState.isTwoFaRequired ||
      authState.isPartiallyAuthenticated;

  if ((!securityState.initialized && !isAllowableWithoutSecurity) ||
      authState.isInitial) {
    if (!isInitialScreen) {
      return AppRoutes.initial;
    }
    return null;
  }

  // 3. WERYFIKACJA BLOKADY (PIN / Biometria)
  final isAppLocked = securityState.shouldShowLock || authState.isLocked;
  if (isAppLocked) {
    if (!isPinScreen) {
      return AppRoutes.pin;
    }
    return null;
  }

  // 4. KROKI POŚREDNIE (2FA / Setup)
  if (authState.isTwoFaRequired) {
    if (!is2FaScreen) {
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

  // 5. ZALOGOWANY I ODBLOKOWANY
  if (authState.isAuthenticated) {
    final isAtAuthFlow = isInitialScreen ||
        isLoginScreen ||
        is2FaScreen ||
        isPinScreen ||
        isSetupScreen;

    if (isAtAuthFlow) {
      return AppRoutes.home;
    }
  }

  return null;
}