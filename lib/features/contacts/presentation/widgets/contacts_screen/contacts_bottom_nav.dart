import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/widgets/app_bottom_nav_bar.dart';

class ContactsBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ContactsBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navTheme = theme.bottomNavigationBarTheme;

    return AppBottomNavBar(
      currentIndex: currentIndex,
      onTap: onTap,
      primaryColor: navTheme.selectedItemColor,
      backgroundColor: theme.colorScheme.surface,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.person_2),
          label: 'Kontakty',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.chat_bubble),
          label: 'Czaty',
        ),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.settings),
          label: 'Opcje',
        ),
      ],
    );
  }
}
