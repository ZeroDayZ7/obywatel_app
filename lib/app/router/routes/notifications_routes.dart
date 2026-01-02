// lib/app/router/routes/notifications_routes.dart
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/features/notifications/presentation/notifications_screen.dart';
import 'package:obywatel_plus/features/notifications/presentation/trash_screen.dart'; // Importuj nową stronę

final notificationsRoutes = [
  AppRoutes.notifications.go(const NotificationsScreen(),
    routes: [AppRoutes.notificationsTrash.go(const TrashScreen())],
  ),
];
