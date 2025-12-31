// work_and_career_routes.dart
import 'package:obywatel_plus/features/work_and_career/presentation/screens/job_offers_screen.dart';
import 'package:obywatel_plus/features/work_and_career/presentation/screens/my_cv_screen.dart';
import 'package:obywatel_plus/features/work_and_career/presentation/screens/work_and_career_home.dart';

import '../app_routes.dart';
import '../extensions/go_router_extensions.dart';

final workAndCareerRoutes = [
  AppRoutes.workAndCareer.go(
    const WorkAndCareerHome(),
    routes: [
      AppRoutes.workAndCareerJobOffers.go(const JobOffersScreen()),
      AppRoutes.workAndCareerMyCV.go(const MyCVScreen())
      ],
  ),
];
