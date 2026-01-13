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

  // Szybkie flagi dla czytelności
  final isPinScreen = path == AppRoutes.pin;
  final isLoginScreen = path == AppRoutes.login;
  final is2FaScreen = path == AppRoutes.twoFaVerify;
  final isSetupScreen = path == AppRoutes.securitySetup;

  final publicRoutes = [AppRoutes.login, AppRoutes.resetPassword];

  // 1️⃣ LOCK SCREEN (PIN) - Zawsze pierwszy
  // Jeśli system wymaga PINu, nie pozwalamy na nic innego.
  if (securityState.shouldShowLock) {
    return isPinScreen ? null : AppRoutes.pin;
  }

  // 2️⃣ LOADING / INITIAL
  if (authState.isLoading || authState.isInitial) return null;

  // 3️⃣ UNATHENTICATED
  if (authState.isUnauthenticated) {
    return publicRoutes.contains(path) ? null : AppRoutes.login;
  }

  // 4️⃣ KROKI POŚREDNIE (2FA / Setup)
  if (authState.isTwoFaRequired) {
    return is2FaScreen ? null : AppRoutes.twoFaVerify;
  }

  if (authState.isPartiallyAuthenticated || !securityState.isSetupCompleted) {
    return isSetupScreen ? null : AppRoutes.securitySetup;
  }

  // 5️⃣ ZALOGOWANY (FULL SUCCESS)
  if (authState.isAuthenticated) {
    // Jeśli user jest zalogowany i wszystko ustawione, a próbuje wejść na ekrany logowania/pin/setup
    final isAtAuthFlow =
        isLoginScreen || is2FaScreen || isPinScreen || isSetupScreen;
    if (isAtAuthFlow) return AppRoutes.home;
  }

  return null;
}
