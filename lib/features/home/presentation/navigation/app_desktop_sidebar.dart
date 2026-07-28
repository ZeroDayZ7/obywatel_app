import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
            backgroundColor: theme.colorScheme.surface,
            indicatorColor: Colors.transparent,
            unselectedIconTheme: IconThemeData(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            selectedIconTheme: const IconThemeData(color: Color(0xFF26C6DA)),
            unselectedLabelTextStyle: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            selectedLabelTextStyle: const TextStyle(
              color: Color(0xFF26C6DA),
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
          color: theme.colorScheme.surface,
          child: Column(
            children: [
              const Divider(height: 1),
              ListTile(
                leading: const Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent,
                ),
                title: const Text(
                  'Wyloguj się',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => _showLogoutDialog(context, ref),
              ),
              const SizedBox(height: 8),
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
