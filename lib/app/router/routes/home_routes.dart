import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/features/documents/presentation/pages/documents_screen.dart';
import 'package:obywatel_plus/features/home/presentation/navigation/app_adaptive_navigation.dart';
import 'package:obywatel_plus/features/home/presentation/pages/profile_screen.dart';
import 'package:obywatel_plus/features/home/presentation/pages/quick_access_screen.dart';
import 'package:obywatel_plus/features/home/presentation/pages/services_screen.dart';
import 'package:obywatel_plus/features/notifications/presentation/notifications_screen.dart';
import 'package:obywatel_plus/features/notifications/presentation/trash_screen.dart';

final homeRoutes = [
  ShellRoute(
    builder: (context, state, child) {
      return AppAdaptiveNavigation(child: child);
    },
    routes: [
      AppRoutes.home.go(const QuickAccessScreen()),
      AppRoutes.services.go(const ServicesScreen()),
      AppRoutes.documents.go(const DocumentsScreen()),
      AppRoutes.notifications.go(const NotificationsScreen()),
      AppRoutes.profile.go(const ProfileScreen()),
    ],
  ),

  // Trasy pełnoekranowe:
  AppRoutes.documents.go(const DocumentsScreen()),
  GoRoute(
    path: '${AppRoutes.notifications}/${AppRoutes.notificationsTrash}',
    builder: (context, state) => const TrashScreen(),
  ),
];
