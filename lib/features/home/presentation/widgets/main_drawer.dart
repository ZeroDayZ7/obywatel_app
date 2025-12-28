import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/config/env.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/widgets/ui/button.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';

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

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  // 1. Statyczna lista elementów - czytelna i bezpieczna typowane
  static const _menuItems = [
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: Column(
        // Column zamiast ListView, jeśli chcesz Logout na dole
        children: [
          const _DrawerHeader(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ..._menuItems.map((item) => _DrawerTile(item: item)),
                const Divider(),
                _LogoutTile(onLogout: () => _showLogoutDialog(context, ref)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. Wydzielona logika dialogu
  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => const _LogoutConfirmDialog(),
    );

    if (shouldLogout == true) {
      await ref.read(authControllerProvider.notifier).logout();
    }
  }
}

/// 🔹 Wydzielony nagłówek (Lepsza wydajność - const)
class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DrawerHeader(
      decoration: BoxDecoration(color: theme.colorScheme.secondary),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _AppLogo(),
            const SizedBox(height: 12),
            Text(
              apiConstants.appName,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Reużywalny komponent logo
class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'assets/images/logo.jpg',
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
    );
  }
}

/// 🔹 Pojedynczy wiersz menu
class _DrawerTile extends StatelessWidget {
  final DrawerItem item;
  const _DrawerTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(item.icon),
      title: Text(item.labelKey.tr()),
      onTap: () {
        context.push(item.route);
        context.pop();
      },
    );
  }
}

/// 🔹 Przycisk wylogowania
class _LogoutTile extends StatelessWidget {
  final VoidCallback onLogout;
  const _LogoutTile({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.redAccent),
      title: Text(
        LocaleKeys.drawer_logout.tr(),
        style: const TextStyle(color: Colors.redAccent),
      ),
      onTap: onLogout,
    );
  }
}

/// 🔹 Wydzielony Dialog (Można go użyć w innych miejscach)
class _LogoutConfirmDialog extends StatelessWidget {
  const _LogoutConfirmDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(LocaleKeys.drawer_logout_title.tr()),
      content: Text(LocaleKeys.drawer_logout_content.tr()),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                labelKey: LocaleKeys.common_cancel,
                variant: AppButtonVariant.text,
                onPressed: () => Navigator.pop(context, false),
              ),
              const SizedBox(width: 12),
              AppButton(
                labelKey: LocaleKeys.drawer_logout,
                variant: AppButtonVariant.danger,
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
