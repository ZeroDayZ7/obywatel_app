import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/core_providers.dart'
    show authServiceProvider;

class MainDrawer extends ConsumerWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = [
      {'icon': Icons.person, 'label': 'Moje konto', 'route': AppRoutes.profile},
      {
        'icon': Icons.notifications,
        'label': 'Powiadomienia',
        'route': AppRoutes.notifications,
      },
      {
        'icon': Icons.settings,
        'label': 'Ustawienia',
        'route': AppRoutes.settings,
      },
    ];

    Future<void> confirmLogout() async {
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Wylogowanie'),
          content: const Text('Czy na pewno chcesz się wylogować?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Anuluj'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Wyloguj'),
            ),
          ],
        ),
      );

      if (shouldLogout == true) {
        final authService = ref.read(authServiceProvider);

        await authService.logout();

        // ⛔ NIE robimy już ręcznego context.go(AppRoutes.login)
        // Router sam przekieruje, bo SessionService zmieniło stan.

        if (context.mounted) Navigator.pop(context);
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
              title: Text(item['label'] as String),
              onTap: () {
                context.push(item['route'] as String);
                Navigator.pop(context);
              },
            ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Wyloguj'),
            onTap: confirmLogout,
          ),
        ],
      ),
    );
  }
}
