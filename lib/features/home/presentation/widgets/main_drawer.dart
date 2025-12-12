import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_service.dart';
import 'package:obywatel_plus/core/lang/locale_keys.g.dart';

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = [
      {
        'icon': Icons.person,
        'labelKey': LocaleKeys.drawer_my_account,
        'route': AppRoutes.profile,
      },
      {
        'icon': Icons.notifications,
        'labelKey': LocaleKeys.drawer_notifications,
        'route': AppRoutes.notifications,
      },
      {
        'icon': Icons.settings,
        'labelKey': LocaleKeys.drawer_settings,
        'route': AppRoutes.settings,
      },
    ];

    Future<void> confirmLogout() async {
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(LocaleKeys.drawer_logout_title.tr()),
          content: Text(LocaleKeys.drawer_logout_content.tr()),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(LocaleKeys.common_cancel.tr()),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () => Navigator.pop(context, true),
              child: Text(LocaleKeys.drawer_logout.tr()),
            ),
          ],
        ),
      );

      if (shouldLogout == true) {
        final authService = ref.read(authServiceProvider);

        await authService.logout();

        if (context.mounted) Navigator.of(context).pop();
      }
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/logo.jpg',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Obywatel+',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          for (final item in items)
            ListTile(
              leading: Icon(item['icon'] as IconData),
              title: Text((item['labelKey'] as String).tr()),
              onTap: () {
                context.push(item['route'] as String);
                Navigator.pop(context);
              },
            ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(LocaleKeys.drawer_logout.tr()),
            onTap: confirmLogout,
          ),
        ],
      ),
    );
  }
}
