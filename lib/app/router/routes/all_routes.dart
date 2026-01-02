// lib/app/router/routes/all_routes.dart
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/routes/notifications_routes.dart';

import 'auth_routes.dart';
import 'chat_routes.dart';
import 'documents_routes.dart';
import 'home_routes.dart';
import 'other_routes.dart';
import 'placeholder_routes.dart';
import 'settings_routes.dart';
import 'work_and_career_routes.dart';

List<GoRoute> getAllRoutes() {
  return [
    ...authRoutes,
    ...homeRoutes,
    ...notificationsRoutes,
    ...settingsRoutes,
    ...workAndCareerRoutes,
    ...documentsRoutes,
    ...chatRoutes,
    ...placeholderRoutes,
    ...otherRoutes,
  ];
}
