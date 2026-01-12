// lib/app/router/redirect_guards.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';

String? authGuard(Ref ref, GoRouterState state) {
  final authState = ref.read(authControllerProvider);
  final securityState = ref.read(securityServiceProvider);

  final isLogin = state.uri.path == AppRoutes.login;
  final is2Fa = state.uri.path == AppRoutes.twoFaVerify;
  final isPin = state.uri.path == AppRoutes.pin;
  final isSecuritySetup = state.uri.path == AppRoutes.securitySetup;

  final publicRoutes = [AppRoutes.login, AppRoutes.resetPassword];

  // 1️⃣ Jeśli system się ładuje (authenticating lub initial), nie robimy redirectu
  if (authState.maybeMap(
    initial: (_) => true,
    authenticating: (_) => true,
    orElse: () => false,
  )) {
    return null;
  }

  // PIN skonfigurowany i lock włączony → jeśli nie jesteśmy na pin screen, redirect
  if (securityState.shouldShowLock) {
    return isPin ? null : AppRoutes.pin;
  }

  // 2️⃣ Niezalogowany
  if (authState.maybeMap(unauthenticated: (_) => true, orElse: () => false)) {
    return publicRoutes.contains(state.uri.path) ? null : AppRoutes.login;
  }

  // 3️⃣ Wymagane 2FA
  if (authState.maybeMap(twoFaRequired: (_) => true, orElse: () => false)) {
    return is2Fa ? null : AppRoutes.twoFaVerify;
  }

  // 🔥 NOWY PUNKT: 3.5️⃣ Częściowo zalogowany (po 2FA, przed zaufaniem urządzeniu)
  if (authState.maybeMap(
    partiallyAuthenticated: (_) => true,
    orElse: () => false,
  )) {
    // Jeśli user ma setupToken, ale nie ukończył setupu bezpieczeństwa -> wyślij na setup
    return isSecuritySetup ? null : AppRoutes.securitySetup;
  }

  // 4️⃣ Zalogowany (Full Success)
  if (authState.maybeMap(authenticated: (_) => true, orElse: () => false)) {
    if (!securityState.isSetupCompleted) {
      return isSecuritySetup ? null : AppRoutes.securitySetup;
    }
    if (isLogin || is2Fa || isPin || isSecuritySetup) return AppRoutes.home;
  }

  return null;
}

// Ten guard sprawdzamy PO authGuard, więc user jest na pewno authenticated
String? securitySetupGuard(Ref ref, GoRouterState state) {
  final security = ref.read(securityServiceProvider);
  final authState = ref.read(authControllerProvider);
  final goingToSetup = state.uri.path == AppRoutes.securitySetup;

  if (!security.initialized) return null;

  final isAuthenticated = authState.maybeMap(
    authenticated: (_) => true,
    orElse: () => false,
  );
  if (!isAuthenticated) return null;

  // KLUCZOWA ZMIANA:
  // Jeśli setup NIE jest ukończony, wymuś ekran setupu.
  // Jeśli jest ukończony, pozwól iść dalej (niezależnie od shouldShowLock).
  if (!security.isSetupCompleted) {
    return goingToSetup ? null : AppRoutes.securitySetup;
  }

  // Jeśli setup ukończony, a użytkownik pcha się na setup -> powrót do Home
  if (security.isSetupCompleted && goingToSetup) {
    return AppRoutes.home;
  }

  return null;
}
