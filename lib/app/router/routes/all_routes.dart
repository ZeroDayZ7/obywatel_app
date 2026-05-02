// lib/app/router/routes/all_routes.dart
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/routes/auth_routes.dart';
import 'package:obywatel_plus/app/router/routes/chat_routes.dart';
import 'package:obywatel_plus/app/router/routes/contacts_routes.dart';
import 'package:obywatel_plus/app/router/routes/documents_routes.dart';
import 'package:obywatel_plus/app/router/routes/home_routes.dart';
import 'package:obywatel_plus/app/router/routes/notifications_routes.dart';
import 'package:obywatel_plus/app/router/routes/other_routes.dart';
import 'package:obywatel_plus/app/router/routes/placeholder_routes.dart';
import 'package:obywatel_plus/app/router/routes/settings_routes.dart';
import 'package:obywatel_plus/app/router/routes/work_and_career_routes.dart';

List<RouteBase> getAllRoutes() {
  return [
    ...authRoutes,
    ...homeRoutes,
    ...notificationsRoutes,
    ...settingsRoutes,
    ...workAndCareerRoutes,
    ...documentsRoutes,
    ...chatRoutes,
    ...contactsRoutes,
    ...placeholderRoutes,
    ...otherRoutes,
  ];
}
