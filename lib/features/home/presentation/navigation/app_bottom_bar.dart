import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/features/home/presentation/navigation/navigation_items.dart';

class AppBottomBar extends StatelessWidget {
  final int notificationCount;

  const AppBottomBar({super.key, required this.notificationCount});

  @override
  Widget build(BuildContext context) {
    final items = AppNavigationItems.getMobileItems(
      notificationCount: notificationCount,
    );
    final theme = Theme.of(context);

    final currentPath = GoRouterState.of(context).uri.path;

    final currentIndex = items.indexWhere(
      (item) => currentPath.startsWith(item.route),
    );

    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          return _buildNavItem(context, items[index], index, currentIndex);
        }),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    NavItem item,
    int index,
    int activeIndex,
  ) {
    final isSelected = activeIndex == index;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final color = isSelected
        ? colorScheme.primary
        : colorScheme.onSurface.withValues(alpha: 0.6);

    final hasBadge = item.badgeCount != null && item.badgeCount! > 0;

    return InkWell(
      onTap: () => context.go(item.route),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Badge(
              isLabelVisible: hasBadge,
              label: Text('${item.badgeCount}'),
              alignment: Alignment.topRight,
              offset: const Offset(6, -6),
              backgroundColor: colorScheme.error,
              textColor: colorScheme.onError,
              child: Icon(
                isSelected ? item.activeIcon : item.icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
