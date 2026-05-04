// lib/app/router/routes/settings_routes.dart
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/features/settings/presentation/pages/active_sessions_screen.dart';
import 'package:obywatel_plus/features/settings/presentation/pages/change_pin_screen.dart';
import 'package:obywatel_plus/features/settings/presentation/pages/notifications_settings_screen.dart';
import 'package:obywatel_plus/features/settings/presentation/pages/security_settings_screen.dart';
import 'package:obywatel_plus/features/settings/presentation/pages/settings_screen.dart';

final settingsRoutes = [
  AppRoutes.settings.go(
    const SettingsScreen(),
    routes: [
      AppRoutes.settingsSecurity.go(const SecuritySettingsScreen()),
      AppRoutes.settingsNotifications.go(const NotificationsSettingsScreen()),
      AppRoutes.settingsActiveSession.go(const ActiveSessionsScreen()),
      AppRoutes.settingsChangePin.go(const ChangePinScreen()),
    ],
  ),
];
