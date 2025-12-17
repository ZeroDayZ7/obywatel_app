// other_routes.dart
import 'package:obywatel_plus/features/payments/presentation/payments_screen.dart';
import 'package:obywatel_plus/features/contacts/presentation/contacts_screen.dart';
import '../app_routes.dart';
import '../extensions/go_router_extensions.dart';

final otherRoutes = [
  AppRoutes.payments.go(const PaymentsScreen()),
  AppRoutes.contacts.go(ContactsScreen()),
];
