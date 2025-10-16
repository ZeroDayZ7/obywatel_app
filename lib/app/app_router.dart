import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// === Importy ekranów ===
import '../features/splash/presentation/splash_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

// === Klasa tras ===
class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const home = '/home';
  static const settings = '/settings';
}

// === Notifier dla autoryzacji (nowy API w Riverpod 3.0) ===
class AuthNotifier extends Notifier<bool> {
  @override
  bool build() => false; // Stan początkowy

  void login() {
    state = true;
  }

  void logout() {
    state = false;
  }
}

final authProvider = NotifierProvider<AuthNotifier, bool>(
  AuthNotifier.new,
).autoDispose;

// === Custom ChangeNotifier do reaktywnego refresh routera ===
class AuthRefreshListenable extends ChangeNotifier {
  late final ProviderSubscription<bool> _subscription;

  AuthRefreshListenable(ProviderRef ref) {
    _subscription = ref.listen<bool>(
      authProvider,
      (_, __) => notifyListeners(), // Trigger refresh na każdej zmianie
    );
  }

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}

final authRefreshListenableProvider = Provider<AuthRefreshListenable>((ref) {
  final listenable = AuthRefreshListenable(ref);
  ref.onDispose(listenable.dispose);
  return listenable;
});

// === Router ===
final appRouterProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ref.watch(authRefreshListenableProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshListenable, // Reaktywny refresh na zmiany auth
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    redirect: (context, state) {
      // Bezpieczny odczyt stanu z globalnego container (działa w 3.0)
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
