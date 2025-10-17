import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/features/splash/presentation/splash_screen.dart';
import 'package:obywatel_plus/features/auth/presentation/login_screen.dart';
import 'package:obywatel_plus/features/home/presentation/home_screen.dart';
import 'package:obywatel_plus/features/settings/presentation/settings_screen.dart';
import 'app_routes.dart';
import 'package:obywatel_plus/providers/auth_provider.dart';
import 'package:obywatel_plus/providers/auth_refresh_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ref.watch(authRefreshListenableProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshListenable,
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeScreen()),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, _) => const SettingsScreen(),
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = ProviderScope.containerOf(context).read(authProvider);
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
