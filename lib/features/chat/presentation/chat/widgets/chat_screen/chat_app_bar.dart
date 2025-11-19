// lib/features/chat/presentation/chat/widgets/chat_app_bar.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chat_colors.dart'; // plik z CyberpunkColors

class ChatAppBar extends StatelessWidget {
  const ChatAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 8,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: CyberpunkColors.background.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(color: CyberpunkColors.primary, width: 1),
        ),
      ),
      child: Row(
        children: [
          _GlowingIcon(
            icon: CupertinoIcons.person_circle,
            color: CyberpunkColors.primary,
            size: 28,
          ),
          const Expanded(
            child: Center(
              child: Text(
                'CHATS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Row(
            children: [
              _GlowingIcon(
                icon: CupertinoIcons.search,
                color: CyberpunkColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              _GlowingIcon(
                icon: CupertinoIcons.add_circled,
                color: CyberpunkColors.accent,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================
// Glowing Icon Widget
// ==================
class _GlowingIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const _GlowingIcon({required this.icon, required this.color, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
