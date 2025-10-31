// lib/app/router/app_router_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/pin/presentation/pin_screen.dart';
import 'package:obywatel_plus/features/splash/presentation/splash_screen.dart';
import 'package:obywatel_plus/features/auth/presentation/login_screen.dart';
import 'package:obywatel_plus/features/home/presentation/home_screen.dart';
import 'package:obywatel_plus/features/home/presentation/profile_screen.dart';
import 'package:obywatel_plus/features/home/presentation/notifications_screen.dart';
import 'package:obywatel_plus/features/home/presentation/documents_screen.dart';
import 'package:obywatel_plus/features/settings/presentation/settings_screen.dart';
import 'package:obywatel_plus/features/settings/presentation/fingerprint_screen.dart';
import 'package:obywatel_plus/features/settings/presentation/set_pin_screen.dart';
import 'package:obywatel_plus/features/settings/presentation/pattern_lock_screen.dart';
import 'package:obywatel_plus/features/settings/presentation/security_setup_screen.dart';
import 'redirect_logic.dart';
import 'app_routes.dart';
import 'package:obywatel_plus/features/auth/application/auth_refresh_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ref.watch(authRefreshListenableProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshListenable,
    routes: [
      _goRouteWithTransition(AppRoutes.splash, const SplashScreen()),
      _goRouteWithTransition(AppRoutes.login, const LoginScreen()),
      _goRouteWithTransition(AppRoutes.pin, const PinScreen()),
      _goRouteWithTransition(AppRoutes.home, const HomeScreen()),
      GoRoute(
        path: AppRoutes.settings,
        pageBuilder: (context, state) =>
            _customPage(state: state, child: const SettingsScreen()),
        routes: [
          _goNestedRoute(AppRoutes.setPin, const SetPinScreen()),
          _goNestedRoute(AppRoutes.patternLock, const PatternLockScreen()),
          _goNestedRoute(AppRoutes.fingerprint, const FingerprintScreen()),
        ],
      ),
      _goRouteWithTransition(
        AppRoutes.securitySetup,
        const SecuritySetupScreen(),
      ),
      _goRouteWithTransition(AppRoutes.profile, const ProfileScreen()),
      _goRouteWithTransition(AppRoutes.documents, const DocumentsScreen()),
      _goRouteWithTransition(
        AppRoutes.notifications,
        const NotificationsScreen(),
      ),
    ],
    redirect: (context, state) => appRedirectLogic(ref, state),
  );
});

// Funkcja pomocnicza dla routingu z animacją
GoRoute _goRouteWithTransition(String path, Widget screen) {
  return GoRoute(
    path: path,
    parentNavigatorKey: _rootNavigatorKey,
    pageBuilder: (context, state) => _customPage(state: state, child: screen),
  );
}

// Funkcja pomocnicza dla nested routes (pod routes)
GoRoute _goNestedRoute(String path, Widget screen) {
  return GoRoute(
    path: path,
    parentNavigatorKey: _rootNavigatorKey,
    pageBuilder: (context, state) => _customPage(state: state, child: screen),
  );
}

// Tworzymy CustomTransitionPage dla animacji
CustomTransitionPage _customPage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeInOut;
      final slideAnimation = Tween<Offset>(
        begin: const Offset(0.1, 0), // subtelne przesunięcie z prawej
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: curve));

      final fadeAnimation = Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(parent: animation, curve: curve));

      return SlideTransition(
        position: slideAnimation,
        child: FadeTransition(opacity: fadeAnimation, child: child),
      );
    },
  );
}
