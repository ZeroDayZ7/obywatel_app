import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const MainAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {
            // ignore: todo
            // TODO: wywołaj funkcję logout (np. ref.read(authProvider.notifier).logout())
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
