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
import 'app_routes.dart';
import 'package:obywatel_plus/providers/auth_provider.dart';
import 'package:obywatel_plus/providers/auth_refresh_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ref.watch(authRefreshListenableProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey, // <-- dodane
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshListenable,
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: AppRoutes.pin, builder: (_, _) => const PinScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeScreen()),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, _) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'set_pin', // <-- bez / na początku
            builder: (_, _) => const SetPinScreen(),
          ),
          GoRoute(
            path: 'pattern_lock',
            builder: (_, _) => const PatternLockScreen(),
          ),
          GoRoute(
            path: 'fingerprint',
            builder: (_, _) => const FingerprintScreen(),
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.profile,
        builder: (_, _) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.documents,
        builder: (_, _) => const DocumentsScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (_, _) => const NotificationsScreen(),
      ),
    ],
    redirect: (context, state) {
      final authState = ProviderScope.containerOf(context).read(authProvider);
      final isLoggedIn = authState.isLoggedIn;
      final goingToLogin = state.uri.path == AppRoutes.login;
      final goingToSplash = state.uri.path == AppRoutes.splash;

      if (!isLoggedIn && !goingToLogin && !goingToSplash) {
        return AppRoutes.login;
      }

      if (isLoggedIn && (goingToLogin || goingToSplash)) {
        return AppRoutes.home;
      }

      return null;
    },
  );
});
