// work_and_career_routes.dart
// placeholdery – dopóki nie masz ekranów
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/features/work_and_career/presentation/pages/applications_page.dart';
import 'package:obywatel_plus/features/work_and_career/presentation/pages/career_advice_page.dart';
import 'package:obywatel_plus/features/work_and_career/presentation/pages/employment_map_page.dart';
import 'package:obywatel_plus/features/work_and_career/presentation/pages/government_support_page.dart';
import 'package:obywatel_plus/features/work_and_career/presentation/pages/internships_page.dart';
import 'package:obywatel_plus/features/work_and_career/presentation/pages/job_offers_page.dart';
import 'package:obywatel_plus/features/work_and_career/presentation/pages/my_cv_page.dart';
import 'package:obywatel_plus/features/work_and_career/presentation/pages/work_and_career_screen.dart';

final workAndCareerRoutes = [
  AppRoutes.workAndCareer.go(
    const WorkAndCareerHome(),
    routes: [
      AppRoutes.workAndCareerJobOffers.go(const JobOffersPage()),
      AppRoutes.workAndCareerMyCV.go(const MyCVScreen()),
      AppRoutes.workAndCareerApplications.go(const ApplicationsPage()),
      AppRoutes.workAndCareerCareerAdvice.go(const CareerAdvicePage()),
      AppRoutes.workInternships.go(const InternshipsPage()),
      AppRoutes.workGovernmentSupport.go(const GovernmentSupportPage()),
      AppRoutes.workEmploymentMap.go(const EmploymentMapPage()),
    ],
  ),
];
