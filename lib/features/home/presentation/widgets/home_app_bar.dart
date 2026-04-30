import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/config/env.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(apiConstants.appName),
      actions: [
        IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        const SizedBox(width: 8),
      ],
    );
  }
}
