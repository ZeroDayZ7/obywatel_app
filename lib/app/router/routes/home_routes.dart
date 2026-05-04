// home_routes.dart
import 'package:obywatel_plus/app/bootstrap/presentation/splash_screen.dart';
// import 'package:obywatel_plus/features/home/presentation/widgets/submenu/test_screen.dart';

import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/features/home/presentation/pages/home_screen.dart';
import 'package:obywatel_plus/features/home/presentation/submenu/help_screen.dart';
import 'package:obywatel_plus/features/home/presentation/submenu/profile_screen.dart';

final homeRoutes = [
  AppRoutes.home.go(const HomeScreen()),
  AppRoutes.profile.go(const ProfileScreen()),
  AppRoutes.help.go(const HelpScreen()),
  AppRoutes.test.go(const SplashScreen()),
  // AppRoutes.test.go(const TestScreen()),
];
