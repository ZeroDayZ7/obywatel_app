// lib/app/router/routes/settings_routes.dart
import 'package:obywatel_plus/features/settings/presentation/notifications_settings_screen.dart';
import 'package:obywatel_plus/features/settings/presentation/security_settings_screen.dart';
import 'package:obywatel_plus/features/settings/presentation/settings_screen.dart';

import '../app_routes.dart';
import '../extensions/go_router_extensions.dart';

final settingsRoutes = [
  AppRoutes.settings.go(
    const SettingsScreen(),
    routes: [
      AppRoutes.settingsSecurity.go(const SecuritySettingsScreen()),
      AppRoutes.settingsNotifications.go(const NotificationsSettingsScreen()),
    ],
  ),
];
