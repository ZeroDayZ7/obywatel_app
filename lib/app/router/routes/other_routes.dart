// other_routes.dart
import 'package:obywatel_plus/app/bootstrap/presentation/force_update_screen.dart';
import 'package:obywatel_plus/app/bootstrap/presentation/initial.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/features/test/presentation/pages/test.dart';

final otherRoutes = [
  AppRoutes.update.go(const ForceUpdateScreen()),
  AppRoutes.initial.go(const InitialSpinnerScreen()),
  AppRoutes.test.go(const TestScreen()),
];
