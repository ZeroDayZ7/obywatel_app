import 'package:easy_localization/easy_localization.dart';
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

    return SafeArea(
      top: false,
      child: Container(
        constraints: const BoxConstraints(minHeight: 68),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
            ),
          ),
        ),
        child: Row(
          children: List.generate(items.length, (index) {
            return Expanded(
              child: _buildNavItem(context, items[index], index, currentIndex),
            );
          }),
        ),
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
              label: Text(
                '${item.badgeCount}',
                textAlign: TextAlign.center,
                strutStyle: const StrutStyle(
                  forceStrutHeight: true,
                  height: 1.0,
                ),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                  color: colorScheme.onError,
                ),
                textHeightBehavior: const TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: false,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4),
              alignment: Alignment.topRight,
              offset: const Offset(6, -6),
              backgroundColor: colorScheme.error,
              child: Icon(
                isSelected ? item.activeIcon : item.icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label.tr(),
              maxLines: 1,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
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