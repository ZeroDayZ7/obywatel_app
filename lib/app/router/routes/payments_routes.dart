// other_routes.dart
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/features/payments/presentation/screens/payments_screen.dart';

final paymentsRoutes = [
  AppRoutes.payments.go(const PaymentsScreen()),
];
