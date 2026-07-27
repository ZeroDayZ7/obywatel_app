import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/home/presentation/navigation/navigation_items.dart';

class AppDesktopSidebar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int notificationCount;

  const AppDesktopSidebar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.notificationCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    final items = AppNavigationItems.getItems(
      notificationCount: notificationCount,
    );
    final theme = Theme.of(context);

    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      extended: true,
      minExtendedWidth: 200,
      backgroundColor: theme.colorScheme.surface,
      unselectedIconTheme: IconThemeData(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      ),
      selectedIconTheme: const IconThemeData(color: Color(0xFF26C6DA)),
      selectedLabelTextStyle: const TextStyle(
        color: Color(0xFF26C6DA),
        fontWeight: FontWeight.bold,
      ),
      destinations: items.map((item) {
        return NavigationRailDestination(
          icon: Badge(
            isLabelVisible: item.badgeCount != null && item.badgeCount! > 0,
            label: Text('${item.badgeCount}'),
            child: Icon(item.icon),
          ),
          selectedIcon: Badge(
            isLabelVisible: item.badgeCount != null && item.badgeCount! > 0,
            label: Text('${item.badgeCount}'),
            child: Icon(item.activeIcon),
          ),
          label: Text(item.label),
        );
      }).toList(),
    );
  }
}
