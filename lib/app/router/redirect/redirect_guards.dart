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

  final isLogin = state.uri.path == AppRoutes.login;
  final is2Fa = state.uri.path == AppRoutes.twoFaVerify;
  final isPin = state.uri.path == AppRoutes.pin;

  // 1️⃣ Jeśli system się ładuje (authenticating lub initial), nie robimy redirectu
  if (authState.maybeMap(
    initial: (_) => true,
    authenticating: (_) => true,
    orElse: () => false,
  )) {
    return null;
  }

  // 2️⃣ Niezalogowany
  if (authState.maybeMap(unauthenticated: (_) => true, orElse: () => false)) {
    return isLogin ? null : AppRoutes.login;
  }

  // 3️⃣ Wymagane 2FA
  if (authState.maybeMap(twoFaRequired: (_) => true, orElse: () => false)) {
    return is2Fa ? null : AppRoutes.twoFaVerify;
  }

  // 4️⃣ Zalogowany
  if (authState.maybeMap(authenticated: (_) => true, orElse: () => false)) {
    // Jeśli PIN jest skonfigurowany i aplikacja powinna być zablokowana
    if (securityState.isPinConfigured && securityState.shouldShowLock) {
      return isPin ? null : AppRoutes.pin;
    }

    // Jeśli wszystko OK, a próbujemy wejść na login/2FA/pin -> Home
    if (isLogin || is2Fa || isPin) return AppRoutes.home;
  }

  // 5️⃣ Domyślnie brak redirectu
  return null;
}

// Ten guard sprawdzamy PO authGuard, więc user jest na pewno authenticated
String? securitySetupGuard(Ref ref, GoRouterState state) {
  final security = ref.read(securityServiceProvider);
  final authState = ref.read(authControllerProvider);
  final goingToSetup = state.uri.path == AppRoutes.securitySetup;

  // Jeśli security nie zainicjalizowane, nie robimy nic
  if (!security.initialized) return null;

  // Ten guard dotyczy tylko pełnej autoryzacji
  final isAuthenticated = authState.maybeMap(
    authenticated: (_) => true,
    orElse: () => false,
  );
  if (!isAuthenticated) return null;

  // Setup nieukończony -> wymuś ekran setupu
  if (!security.isSetupCompleted) {
    return goingToSetup ? null : AppRoutes.securitySetup;
  }

  // Setup ukończony -> nie pozwól wracać na setup
  if (security.isSetupCompleted && goingToSetup) {
    return AppRoutes.home;
  }

  // Domyślnie brak redirectu
  return null;
}
