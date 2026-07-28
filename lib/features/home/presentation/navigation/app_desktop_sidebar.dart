import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/home/presentation/navigation/navigation_items.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/drawer/logout_confirm_dialog.dart';

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

    return Column(
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
            backgroundColor: colorScheme.surface,
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
        Container(
          width: 200,
          color: colorScheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(height: 1, color: colorScheme.outlineVariant),
              const SizedBox(height: 12),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  hoverColor: colorScheme.error.withValues(alpha: 0.08),
                  splashColor: colorScheme.error.withValues(alpha: 0.12),
                  onTap: () => _showLogoutDialog(context, ref),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout_rounded,
                          size: 20,
                          color: colorScheme.error,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            LocaleKeys.common_logout.tr(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final action = await LogoutConfirmDialog.show(context);
    if (action == null || !context.mounted) return;

    final authController = ref.read(authControllerProvider.notifier);

    switch (action) {
      case LogoutAction.unpairAndReset:
        await authController.unpairAndReset();
        break;
      case LogoutAction.logout:
        await authController.logout();
        break;
    }
  }
}
