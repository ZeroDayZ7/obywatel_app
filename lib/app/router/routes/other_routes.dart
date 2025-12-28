// other_routes.dart
import 'package:obywatel_plus/app/bootstrap/presentation/force_update_screen.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/initial.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/features/contacts/presentation/contacts_screen.dart';
import 'package:obywatel_plus/features/payments/presentation/payments_screen.dart';

final otherRoutes = [
  AppRoutes.update.go(const ForceUpdateScreen()),
  AppRoutes.payments.go(const PaymentsScreen()),
  AppRoutes.contacts.go(ContactsScreen()),
  AppRoutes.initial.go(InitialSpinnerScreen ()),
];
