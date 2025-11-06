import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/features/auth/application/auth_provider.dart';
import 'package:obywatel_plus/features/auth/application/auth_service_provider.dart';

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
        ref.read(authProvider.notifier).logout();
        if (context.mounted) context.go(AppRoutes.login);
      }
    }

    return NavigationDrawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
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

        // Elementy nawigacji
        ...items.map(
          (item) => NavigationDrawerDestination(
            icon: Icon(item['icon'] as IconData),
            label: Text(item['label'] as String),
          ),
        ),

        const Divider(),

        NavigationDrawerDestination(
          icon: const Icon(Icons.logout),
          label: const Text('Wyloguj'),
        ),
      ],
      onDestinationSelected: (index) {
        if (index < items.length) {
          final route = items[index]['route'] as String;
          context.push(route);
        } else {
          confirmLogout();
        }
      },
    );
  }
}
