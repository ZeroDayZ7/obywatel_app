import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/widgets/app_bottom_nav_bar.dart';

import 'package:obywatel_plus/features/chat/presentation/widgets/chat_screen/chat_colors.dart';

class CyberpunkBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CyberpunkBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBottomNavBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: CyberpunkColors.background,
      primaryColor: CyberpunkColors.primary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_rounded),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group_rounded),
          label: 'Groups',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded),
          label: 'Settings',
        ),
      ],
    );
  }
}
