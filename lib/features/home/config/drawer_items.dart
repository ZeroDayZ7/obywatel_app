import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';

class DrawerItem {
  final IconData icon;
  final String labelKey;
  final String route;

  const DrawerItem({
    required this.icon,
    required this.labelKey,
    required this.route,
  });
}

class DrawerConstants {
  static const List<DrawerItem> menuItems = [
    DrawerItem(
      icon: Icons.person,
      labelKey: LocaleKeys.drawer_my_account,
      route: AppRoutes.profile,
    ),
    DrawerItem(
      icon: Icons.notifications,
      labelKey: LocaleKeys.drawer_notifications,
      route: AppRoutes.notifications,
    ),
    DrawerItem(
      icon: Icons.settings,
      labelKey: LocaleKeys.drawer_settings,
      route: AppRoutes.settings,
    ),
  ];
}
