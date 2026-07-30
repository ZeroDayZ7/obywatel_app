import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/features/contacts/presentation/pages/contacts_screen.dart';

final List<RouteBase> contactsRoutes = [
  AppRoutes.contacts.go(const ContactsScreen()),
];
