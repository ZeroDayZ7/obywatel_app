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
  final goingToSplash = path == AppRoutes.splash;
  final goingToPin = path == AppRoutes.pin;

  // nie zalogowany → login
  if (!isLoggedIn && !goingToLogin && !goingToSplash) {
    return AppRoutes.login;
  }

  // zalogowany i próbuje wejść na login lub splash → home
  if (isLoggedIn && (goingToLogin || goingToSplash)) {
    return AppRoutes.home;
  }

  // zalogowany i powinna być blokada → PIN
  if (isLoggedIn && shouldShowLock && !goingToPin) {
    return AppRoutes.pin;
  }

  return null;
}
