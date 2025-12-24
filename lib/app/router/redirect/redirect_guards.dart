import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/bootstrap/force_update_provider.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/core_providers.dart';
import 'package:obywatel_plus/features/auth/application/login/login_provider.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';

String? forceUpdateGuard(Ref ref, GoRouterState state) {
  final logger = ref.read(appLoggerProvider);
  final forceUpdate = ref.read(forceUpdateProvider);

  if (forceUpdate.required) {
    logger.w('Force update required, redirecting to update screen');
    if (state.uri.path != AppRoutes.update) {
      return AppRoutes.update;
    }
  }
  return null;
}

String? authGuard(Ref ref, GoRouterState state) {
  final isLoggedIn = ref.read(sessionServiceProvider).isLoggedIn;
  final goingToLogin = state.uri.path == AppRoutes.login;

  if (!isLoggedIn && !goingToLogin) {
    return AppRoutes.login;
  }
  if (isLoggedIn && goingToLogin) {
    return AppRoutes.home;
  }
  return null;
}

String? twoFaGuard(Ref ref, GoRouterState state) {
  final loginState = ref.read(loginNotifierProvider);
  final goingTo2Fa = state.uri.path == AppRoutes.twoFaVerify;

  // Jeśli 2FA wymagane i user nie jest na ekranie 2FA → redirect na /2fa
  if (loginState.twoFaRequired && !goingTo2Fa) {
    return AppRoutes.twoFaVerify;
  }

  // Jeśli 2FA zweryfikowane, a user próbuje wejść na /2fa → redirect do home
  if (!loginState.twoFaRequired && goingTo2Fa) {
    return AppRoutes.home;
  }

  return null;
}

String? securitySetupGuard(Ref ref, GoRouterState state) {
  final security = ref.read(securityServiceProvider);
  final goingToSetup = state.uri.path == AppRoutes.securitySetup;

  // Jeśli setup nieukończony -> wymuś setup
  if (security.initialized && !security.isSetupCompleted && !goingToSetup) {
    return AppRoutes.securitySetup;
  }

  // Jeśli setup ukończony a user próbuje wejść na setup (np. przyciskiem wstecz) -> Home
  if (security.isSetupCompleted && goingToSetup) {
    return AppRoutes.home;
  }

  return null;
}

String? pinLockGuard(Ref ref, GoRouterState state) {
  final security = ref.read(securityServiceProvider);
  final goingToPin = state.uri.path == AppRoutes.pin;

  // 1. Aplikacja wymaga blokady -> idź do PIN
  if (security.shouldShowLock && !goingToPin) {
    return AppRoutes.pin;
  }

  // 2. Aplikacja NIE wymaga blokady, ale jesteśmy na PIN -> idź do Home
  // To jest kluczowa poprawka!
  if (!security.shouldShowLock && goingToPin) {
    return AppRoutes.home;
  }

  return null;
}
