import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat_colors.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CyberpunkColors.background.withValues(alpha: 0.95),
      elevation: 0,
      centerTitle: true,
      // To automatycznie doda strzałkę powrotu, jeśli jest dostępna
      automaticallyImplyLeading: true,
      // Dolna krawędź w stylu Cyberpunk
      shape: Border(
        bottom: BorderSide(color: CyberpunkColors.primary, width: 1),
      ),
      leading: _buildLeading(context),
      title: const Text(
        'CHATS',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 3,
          color: Colors.white,
        ),
      ),
      actions: [
        _GlowingIcon(
          icon: CupertinoIcons.search,
          color: CyberpunkColors.primary,
          size: 24,
          onPressed: () {},
        ),
        const SizedBox(width: 4),
        _GlowingIcon(
          icon: CupertinoIcons.add_circled,
          color: CyberpunkColors.accent,
          size: 24,
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget? _buildLeading(BuildContext context) {
    final bool canPop = ModalRoute.of(context)?.canPop ?? false;

    if (canPop) {
      return IconButton(
        icon: const Icon(CupertinoIcons.back),
        color: CyberpunkColors.primary,
        onPressed: () => Navigator.of(context).pop(),
      );
    }

    return Center(
      child: _GlowingIcon(
        icon: CupertinoIcons.person_circle,
        color: CyberpunkColors.primary,
        size: 28,
        onPressed: () {},
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _GlowingIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onPressed;

  const _GlowingIcon({
    required this.icon,
    required this.color,
    required this.onPressed,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}
