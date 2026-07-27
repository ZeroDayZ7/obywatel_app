import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';

class NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final int? badgeCount;
  final String route;

  const NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
    this.badgeCount,
  });
}

abstract class AppNavigationItems {
  static List<NavItem> getItems({int notificationCount = 0}) {
    return [
      const NavItem(
        label: 'Start',
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        route: AppRoutes.home,
      ),
      const NavItem(
        label: 'Aplikacje',
        icon: Icons.grid_view_outlined,
        activeIcon: Icons.grid_view_rounded,
        route: AppRoutes.services,
      ),
      const NavItem(
        label: 'Dokumenty',
        icon: Icons.badge_outlined,
        activeIcon: Icons.badge_rounded,
        route: AppRoutes.documents,
      ),
      NavItem(
        label: 'Powiadomienia',
        icon: Icons.notifications_none_rounded,
        activeIcon: Icons.notifications_rounded,
        badgeCount: notificationCount,
        route: AppRoutes.notifications,
      ),
      const NavItem(
        label: 'Profil',
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        route: AppRoutes.profile,
      ),
    ];
  }
}
