// lib/app/router/redirect_guards.dart
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/force_update_provider.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/security/security/security_notifier.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';

String? forceUpdateGuard(Ref ref, GoRouterState state) {
  final forceUpdate = ref.read(forceUpdateProvider);
  if (forceUpdate.required && state.uri.path != AppRoutes.update) {
    return AppRoutes.update;
  }
  return null;
}

String? authGuard(Ref ref, GoRouterState state) {
  final authState = ref.read(authControllerProvider);
  final securityState = ref.read(securityServiceProvider);

  // 1. BLOKADA INITIAL: Jeśli system się ładuje, nie pozwól na żaden redirect.
  // GoRouter zostanie na obecnym ekranie (np. Splash) dopóki status się nie zmieni.
  if (authState.status == AuthStatus.initial) return null;

  final isLogin = state.uri.path == AppRoutes.login;
  final is2Fa = state.uri.path == AppRoutes.twoFaVerify;
  final isPin = state.uri.path == AppRoutes.pin;

  if (authState.isLoading) return null;

  // 2. NIEZALOGOWANY
  if (authState.status == AuthStatus.unauthenticated) {
    return isLogin ? null : AppRoutes.login;
  }

  // 3. WYMAGANE 2FA
  if (authState.status == AuthStatus.twoFaRequired) {
    return is2Fa ? null : AppRoutes.twoFaVerify;
  }

  // 4. ZALOGOWANY
  if (authState.status == AuthStatus.authenticated) {
    // KLUCZOWE: Jeśli mamy skonfigurowany PIN i aplikacja powinna być zablokowana
    if (securityState.isPinConfigured && securityState.shouldShowLock) {
      return isPin ? null : AppRoutes.pin;
    }

    // Jeśli wszystko OK, a próbujemy wejść na login/pin -> Home
    if (isLogin || is2Fa || isPin) {
      return AppRoutes.home;
    }
  }

  return null;
}

// Ten guard sprawdzamy PO authGuard, więc user jest na pewno authenticated
String? securitySetupGuard(Ref ref, GoRouterState state) {
  final security = ref.read(securityServiceProvider);
  final authState = ref.read(authControllerProvider);
  final goingToSetup = state.uri.path == AppRoutes.securitySetup;
  if (!security.initialized) return null;

  // Jeśli nie jesteśmy w pełni zalogowani, ten guard nas nie dotyczy
  if (authState.status != AuthStatus.authenticated) return null;

  // Jeśli setup nieukończony -> wymuś ekran setupu
  if (security.initialized && !security.isSetupCompleted) {
    return goingToSetup ? null : AppRoutes.securitySetup;
  }

  // Jeśli setup ukończony, a user próbuje wejść na setup -> Home
  if (security.isSetupCompleted && goingToSetup) {
    return AppRoutes.home;
  }

  return null;
}
