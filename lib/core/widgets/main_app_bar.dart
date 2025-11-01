import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/features/auth/application/auth_provider.dart';
import 'package:obywatel_plus/features/auth/application/auth_service_provider.dart';

class MainAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const MainAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            )
          : null,
      title: Text(title),
      centerTitle: true,
      actions: [
        IconButton(
          tooltip: 'Powiadomienia',
          icon: const Icon(Icons.notifications),
          onPressed: () => context.push(AppRoutes.notifications),
        ),
        IconButton(
          tooltip: 'Ustawienia',
          icon: const Icon(Icons.settings),
          onPressed: () => context.push(AppRoutes.settings),
        ),
        IconButton(
          tooltip: 'Wyloguj',
          icon: const Icon(Icons.logout),
          onPressed: () async {
            final authService = ref.read(authServiceProvider);

            await authService.logout();
            ref.read(authProvider.notifier).logout();

            if (context.mounted) {
              context.go(AppRoutes.login);
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
