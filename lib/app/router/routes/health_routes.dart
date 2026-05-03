import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/features/health/presentation/pages/health_details_screen.dart';
import 'package:obywatel_plus/features/health/presentation/pages/health_screen.dart';
import 'package:obywatel_plus/features/health/presentation/pages/health_shell_wrapper.dart';

final healthRoutes = [
  ShellRoute(
    builder: (context, state, child) {
      return HealthShellWrapper(state: state, child: child);
    },
    routes: [
      // Główny ekran zdrowia
      GoRoute(
        path: AppRoutes.health,
        builder: (context, state) => const HealthScreen(),
        routes: [
          // Podstrony (zostaną wstrzyknięte jako 'child' do HealthShellWrapper)
          GoRoute(
            path: AppRoutes.healthPrescriptions,
            builder: (context, state) =>
                const HealthDetailsScreen(type: 'prescriptions'),
          ),
          GoRoute(
            path: AppRoutes.healthReferrals,
            builder: (context, state) =>
                const HealthDetailsScreen(type: 'referrals'),
          ),
          GoRoute(
            path: AppRoutes.healthHistory,
            builder: (context, state) =>
                const HealthDetailsScreen(type: 'history'),
          ),
          GoRoute(
            path: AppRoutes.healthVaccinations,
            builder: (context, state) =>
                const HealthDetailsScreen(type: 'vaccinations'),
          ),
        ],
      ),
    ],
  ),
];
