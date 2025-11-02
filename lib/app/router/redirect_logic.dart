// lib/app/router/redirect_logic.dart
import 'package:obywatel_plus/features/auth/application/auth_provider.dart';
import 'package:obywatel_plus/core/security/security_service_provider.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

String? appRedirectLogic(Ref ref, GoRouterState state) {
  final auth = ref.read(authProvider);
  final securityService = ref.read(securityServiceProvider);

  final path = state.uri.path;
  final isLoggedIn = auth.isLoggedIn;
  final shouldShowLock = securityService.shouldShowLock;

  final goingToLogin = path == AppRoutes.login;
  final goingToPin = path == AppRoutes.pin;

  // 1. Nie zalogowany → login
  if (!isLoggedIn && !goingToLogin) {
    return AppRoutes.login;
  }

  // 2. Zalogowany, brak lokalnej blokady, ale powinien ustawić → PIN setup
  if (isLoggedIn && !shouldShowLock && !goingToPin) {
    return AppRoutes.securitySetup;
  }

  // 3. Zalogowany i powinna być blokada → PIN
  if (isLoggedIn && shouldShowLock && !goingToPin) {
    return AppRoutes.pin;
  }

  // 4. Zalogowany i próbuje wejść na login → home
  if (isLoggedIn && goingToLogin) {
    return AppRoutes.home;
  }

  return null;
}
