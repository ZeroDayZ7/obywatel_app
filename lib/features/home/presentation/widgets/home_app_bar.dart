import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/config/env.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        apiConstants.appName,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: theme.colorScheme.onSurface,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      actions: [
        IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        const SizedBox(width: 8),
      ],
    );
  }
}
