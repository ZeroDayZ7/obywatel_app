import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/features/home/presentation/navigation/navigation_items.dart';

class AppBottomBar extends StatelessWidget {
  final int notificationCount;

  const AppBottomBar({super.key, this.notificationCount = 4});

  @override
  Widget build(BuildContext context) {
    final items = AppNavigationItems.getItems(
      notificationCount: notificationCount,
    );
    final theme = Theme.of(context);
    const activeColor = Color(0xFF26C6DA);

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
          return _buildNavItem(
            context,
            items[index],
            index,
            currentIndex,
            activeColor,
          );
        }),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    NavItem item,
    int index,
    int activeIndex,
    Color activeColor,
  ) {
    final isSelected = activeIndex == index;
    final theme = Theme.of(context);
    final color = isSelected
        ? activeColor
        : theme.colorScheme.onSurface.withValues(alpha: 0.6);

    return InkWell(
      onTap: () => context.go(item.route),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? item.activeIcon : item.icon,
                  color: color,
                  size: 24,
                ),
                if (item.badgeCount != null && item.badgeCount! > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '${item.badgeCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
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
