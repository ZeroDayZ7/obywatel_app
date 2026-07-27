import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/features/home/presentation/navigation/navigation_items.dart';

class AppDesktopSidebar extends StatelessWidget {
  final int notificationCount;

  const AppDesktopSidebar({super.key, this.notificationCount = 4});

  @override
  Widget build(BuildContext context) {
    final items = AppNavigationItems.getItems(
      notificationCount: notificationCount,
    );
    final theme = Theme.of(context);

    final currentPath = GoRouterState.of(context).uri.path;
    final currentIndex = items.indexWhere(
      (item) => currentPath.startsWith(item.route),
    );

    final selectedIndex = currentIndex < 0 ? 0 : currentIndex;

    return NavigationRail(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        if (index >= 0 && index < items.length) {
          context.go(items[index].route);
        }
      },
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
