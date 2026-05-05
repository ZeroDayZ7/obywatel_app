import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/builders/shell_route_builder.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/features/contacts/presentation/pages/contacts_favorites_screen.dart';
import 'package:obywatel_plus/features/contacts/presentation/pages/contacts_screen.dart';
import 'package:obywatel_plus/features/contacts/presentation/pages/contacts_settings_screen.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_bottom_nav.dart';

final List<RouteBase> contactsRoutes = [
  buildShellRoute(
    titles: AppRoutes.contactsTitles,
    navBarBuilder: (index, onTap) =>
        ContactsBottomNav(currentIndex: index, onTap: onTap),
    branchRoutes: [
      [
        AppRoutes.contacts.go(const ContactsScreen()),
      ],
      [
        AppRoutes.contactsFavorites.go(const ContactsFavoritesScreen()),
      ],
      [
        AppRoutes.contactsSettings.go(const ContactsSettingsScreen()),
      ],
    ],
  ),
];