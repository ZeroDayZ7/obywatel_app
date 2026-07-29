import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/features/home/presentation/navigation/navigation_items.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/drawer/logout_tile.dart';

class AppDesktopSidebar extends ConsumerWidget {
  final int notificationCount;

  const AppDesktopSidebar({super.key, this.notificationCount = 4});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = AppNavigationItems.getDesktopItems(
      notificationCount: notificationCount,
    );
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final currentPath = GoRouterState.of(context).uri.path;
    final currentIndex = items.indexWhere(
      (item) =>
          currentPath == item.route || currentPath.startsWith('${item.route}/'),
    );

    final selectedIndex = currentIndex < 0 ? null : currentIndex;

    return Container(
      width: 200,
      color: colorScheme.surface,
      child: Column(
        children: [
          Expanded(
            child: NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                if (index >= 0 && index < items.length) {
                  context.go(items[index].route);
                }
              },
              extended: true,
              minExtendedWidth: 200,
              backgroundColor: Colors.transparent,
              indicatorColor: Colors.transparent,
              unselectedIconTheme: IconThemeData(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              selectedIconTheme: IconThemeData(color: colorScheme.primary),
              unselectedLabelTextStyle: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              selectedLabelTextStyle: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              destinations: items.map((item) {
                return NavigationRailDestination(
                  icon: Badge(
                    isLabelVisible:
                        item.badgeCount != null && item.badgeCount! > 0,
                    label: Text('${item.badgeCount}'),
                    child: Icon(item.icon),
                  ),
                  selectedIcon: Badge(
                    isLabelVisible:
                        item.badgeCount != null && item.badgeCount! > 0,
                    label: Text('${item.badgeCount}'),
                    child: Icon(item.activeIcon),
                  ),
                  label: Text(item.label),
                );
              }).toList(),
            ),
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Material(color: Colors.transparent, child: LogoutTile()),
          ),
        ],
      ),
    );
  }
}
