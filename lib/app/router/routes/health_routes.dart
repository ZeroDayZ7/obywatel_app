import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/features/health/presentation/pages/health_details_screen.dart';
import 'package:obywatel_plus/features/health/presentation/pages/health_screen.dart';

final healthRoutes = [
  AppRoutes.health.go(
    const HealthScreen(),
    routes: [
      AppRoutes.healthPrescriptions.go(
        const HealthDetailsScreen(type: AppRoutes.healthPrescriptions),
      ),
      AppRoutes.healthReferrals.go(
        const HealthDetailsScreen(type: AppRoutes.healthReferrals),
      ),
      AppRoutes.healthHistory.go(
        const HealthDetailsScreen(type: AppRoutes.healthHistory),
      ),
      AppRoutes.healthVaccinations.go(
        const HealthDetailsScreen(type: AppRoutes.healthVaccinations),
      ),
      AppRoutes.healthInsurance.go(
        const HealthDetailsScreen(type: AppRoutes.healthInsurance),
      ),
    ],
  ),
];
