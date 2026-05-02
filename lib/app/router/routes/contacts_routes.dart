import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/widgets/app_shell_wrapper.dart';
import 'package:obywatel_plus/features/contacts/presentation/pages/contacts_favorites_screen.dart';
import 'package:obywatel_plus/features/contacts/presentation/pages/contacts_screen.dart';
import 'package:obywatel_plus/features/contacts/presentation/pages/contacts_settings_screen.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_bottom_nav.dart';

final List<RouteBase> contactsRoutes = [
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return AppShellWrapper(
        navigationShell: navigationShell,
        titles: AppRoutes.contactsTitles,
        navBarBuilder: (index, onTap) =>
            ContactsBottomNav(currentIndex: index, onTap: onTap),
      );
    },
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.contacts,
            builder: (context, state) => const ContactsScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.contactsFavorites,
            builder: (context, state) => const ContactsFavoritesScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.contactsSettings,
            builder: (context, state) => const ContactsSettingsScreen(),
          ),
        ],
      ),
    ],
  ),
];
