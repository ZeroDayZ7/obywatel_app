// lib/features/work_and_career/router/work_and_career_routes.dart

import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/extensions/feature_module_extension.dart';
// Importy stron (Pages)
import 'package:obywatel_plus/features/work_and_career/presentation/pages/applications_page.dart';
import 'package:obywatel_plus/features/work_and_career/presentation/pages/career_advice_page.dart';
import 'package:obywatel_plus/features/work_and_career/presentation/pages/employment_map_page.dart';
import 'package:obywatel_plus/features/work_and_career/presentation/pages/government_support_page.dart';
import 'package:obywatel_plus/features/work_and_career/presentation/pages/internships_page.dart';
import 'package:obywatel_plus/features/work_and_career/presentation/pages/job_offers_page.dart';
import 'package:obywatel_plus/features/work_and_career/presentation/pages/my_cv_page.dart';
import 'package:obywatel_plus/features/work_and_career/presentation/pages/work_and_career_screen.dart';

/// Definicja tras modułu Praca i Kariera jako spójny Feature Module.
/// Zastosowanie extension .asFeatureModule automatycznie opakowuje trasy w
/// FeatureShell z dynamicznym AppBarem i wspólnym AppScaffoldem.
final workAndCareerRoutes =
    [
      GoRoute(
        path: AppRoutes.workAndCareer,
        builder: (context, state) => const WorkAndCareerHome(),
        routes: [
          GoRoute(
            path: AppRoutes.workAndCareerJobOffers,
            builder: (context, state) => const JobOffersPage(),
          ),
          GoRoute(
            path: AppRoutes.workAndCareerMyCV,
            builder: (context, state) => const MyCVScreen(),
          ),
          GoRoute(
            path: AppRoutes.workAndCareerApplications,
            builder: (context, state) => const ApplicationsPage(),
          ),
          GoRoute(
            path: AppRoutes.workAndCareerCareerAdvice,
            builder: (context, state) => const CareerAdvicePage(),
          ),
          GoRoute(
            path: AppRoutes.workInternships,
            builder: (context, state) => const InternshipsPage(),
          ),
          GoRoute(
            path: AppRoutes.workGovernmentSupport,
            builder: (context, state) => const GovernmentSupportPage(),
          ),
          GoRoute(
            path: AppRoutes.workEmploymentMap,
            builder: (context, state) => const EmploymentMapPage(),
          ),
        ],
      ),
    ].asFeatureModule(
      defaultTitle: 'Praca i Kariera',
      routeTitles: {
        // Mapowanie pełnych ścieżek URL na tytuły wyświetlane w AppBar
        AppRoutes.workAndCareer: 'Praca i Kariera',
        '${AppRoutes.workAndCareer}/${AppRoutes.workAndCareerJobOffers}':
            'Oferty pracy',
        '${AppRoutes.workAndCareer}/${AppRoutes.workAndCareerMyCV}':
            'Mój Kreator CV',
        '${AppRoutes.workAndCareer}/${AppRoutes.workAndCareerApplications}':
            'Moje aplikacje',
        '${AppRoutes.workAndCareer}/${AppRoutes.workAndCareerCareerAdvice}':
            'Porady zawodowe',
        '${AppRoutes.workAndCareer}/${AppRoutes.workInternships}':
            'Staż i praktyki',
        '${AppRoutes.workAndCareer}/${AppRoutes.workGovernmentSupport}':
            'Wsparcie publiczne',
        '${AppRoutes.workAndCareer}/${AppRoutes.workEmploymentMap}':
            'Mapa zatrudnienia',
      },
    );
