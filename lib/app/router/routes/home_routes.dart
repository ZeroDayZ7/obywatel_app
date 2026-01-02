// home_routes.dart
import 'package:obywatel_plus/features/home/presentation/help_screen.dart';
import 'package:obywatel_plus/features/home/presentation/home_screen.dart';
import 'package:obywatel_plus/features/home/presentation/profile_screen.dart';
import 'package:obywatel_plus/features/home/presentation/test_screen.dart';

import '../app_routes.dart';
import '../extensions/go_router_extensions.dart';

final homeRoutes = [
  AppRoutes.home.go(const HomeScreen()),
  AppRoutes.profile.go(const ProfileScreen()),
  AppRoutes.help.go(const HelpScreen()),
  AppRoutes.test.go(const TestScreen()),
];
