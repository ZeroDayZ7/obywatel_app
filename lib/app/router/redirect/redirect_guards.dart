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

  logger.d(
    '[Router Guard] Evaluating path: "$path" | '
    'Security init: ${securityState.initialized}, lock: ${securityState.shouldShowLock} | '
    'Auth state: ${authState.runtimeType}',
  );

  final isInitialScreen = path == AppRoutes.initial;
  final isPinScreen = path == AppRoutes.pin;
  final isLoginScreen = path == AppRoutes.login;
  final is2FaScreen = path == AppRoutes.twoFaVerify;
  final isSetupScreen = path == AppRoutes.securitySetup;

  final publicRoutes = [AppRoutes.login, AppRoutes.resetPassword];

  // 1. DOKĄD SECURITY NIE JEST GOTOWE LUB AUTH JEST W TRAKCIE STARTU -> TRZYMAMY NA /initial
  if (!securityState.initialized ||
      authState.isLoading ||
      authState.isInitial) {
    logger.d(
      '[Router Guard] Step 1 (Initialization check): Hold on /initial | '
      'securityInit=${securityState.initialized}, '
      'authIsLoading=${authState.isLoading}, '
      'authIsInitial=${authState.isInitial}',
    );

    if (!isInitialScreen) {
      logger.d('[Router Guard] Redirecting to ${AppRoutes.initial}');
      return AppRoutes.initial;
    }

    logger.d('[Router Guard] Already on initial screen -> Allowing navigation');
    return null;
  }

  // 2. WERYFIKACJA BLOKADY (Kolejność: Security Service -> Auth State)
  final isAppLocked = securityState.shouldShowLock || authState.isLocked;
  logger.d(
    '[Router Guard] Step 2 (Lock check): isAppLocked=$isAppLocked '
    '(shouldShowLock=${securityState.shouldShowLock}, isLocked=${authState.isLocked})',
  );

  if (isAppLocked) {
    if (!isPinScreen) {
      logger.d(
        '[Router Guard] Application is locked -> Forcing redirect to PIN screen (${AppRoutes.pin})',
      );
      return AppRoutes.pin;
    }

    logger.d(
      '[Router Guard] Application is locked, already on PIN screen -> Allowing navigation',
    );
    return null;
  }

  // 3. UNAUTHENTICATED (Czysty storage / brak sesji)
  if (authState.isUnauthenticated) {
    final isPublic = publicRoutes.contains(path);
    logger.d(
      '[Router Guard] Step 3 (Unauthenticated check): isUnauthenticated=true | '
      'path="$path" isPublic=$isPublic',
    );

    if (!isPublic) {
      logger.d(
        '[Router Guard] Unauthorized access to private route "$path" -> Redirecting to Login (${AppRoutes.login})',
      );
      return AppRoutes.login;
    }

    logger.d(
      '[Router Guard] Accessing public route "$path" while unauthenticated -> Allowing navigation',
    );
    return null;
  }

  // 4. KROKI POŚREDNIE (2FA / Setup)
  if (authState.isTwoFaRequired) {
    logger.d('[Router Guard] Step 4a (2FA check): 2FA verification required');

    if (!is2FaScreen) {
      logger.d(
        '[Router Guard] Redirecting to 2FA verification screen (${AppRoutes.twoFaVerify})',
      );
      return AppRoutes.twoFaVerify;
    }

    logger.d('[Router Guard] Already on 2FA screen -> Allowing navigation');
    return null;
  }

  if (authState.isPartiallyAuthenticated) {
    logger.d(
      '[Router Guard] Step 4b (Partial Auth check): setupCompleted=${securityState.isSetupCompleted}',
    );

    if (!securityState.isSetupCompleted) {
      if (!isSetupScreen) {
        logger.d(
          '[Router Guard] Security setup not completed -> Redirecting to ${AppRoutes.securitySetup}',
        );
        return AppRoutes.securitySetup;
      }

      logger.d(
        '[Router Guard] Already on security setup screen -> Allowing navigation',
      );
      return null;
    }

    logger.d(
      '[Router Guard] Security setup completed for partially authenticated user -> Redirecting to Home (${AppRoutes.home})',
    );
    return AppRoutes.home;
  }

  // 5. ZALOGOWANY
  if (authState.isAuthenticated) {
    final isAtAuthFlow =
        isInitialScreen ||
        isLoginScreen ||
        is2FaScreen ||
        isPinScreen ||
        isSetupScreen;

    logger.d(
      '[Router Guard] Step 5 (Authenticated check): isAuthenticated=true | '
      'isAtAuthFlow=$isAtAuthFlow',
    );

    if (isAtAuthFlow) {
      logger.d(
        '[Router Guard] User is fully authenticated but currently in auth flow ($path) -> Redirecting to Home (${AppRoutes.home})',
      );
      return AppRoutes.home;
    }

    logger.d(
      '[Router Guard] Authenticated user accessing main app route ($path) -> Allowing navigation',
    );
  }

  logger.d(
    '[Router Guard] No redirection rules triggered -> Allowing navigation to "$path"',
  );
  return null;
}
