import 'package:flutter/material.dart';

class UserChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  const UserChatAppBar({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(username),
      backgroundColor: const Color(0xFF1C1C28),
      elevation: 1,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
