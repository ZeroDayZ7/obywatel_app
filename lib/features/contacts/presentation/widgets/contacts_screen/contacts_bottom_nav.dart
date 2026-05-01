// lib/features/contacts/presentation/widgets/contacts_screen/contacts_bottom_nav.dart

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    // Pobieramy kolory z motywu zamiast z parametrów
    final theme = Theme.of(context);
    final navTheme = theme.bottomNavigationBarTheme;
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: BottomNavigationBar(
          onTap: onTap,
          currentIndex: currentIndex,
          // Automatyczne kolory z motywu:
          backgroundColor: isDark
              ? theme.colorScheme.surface.withAlpha(128)
              : Colors.white.withAlpha(180),
          selectedItemColor: navTheme.selectedItemColor,
          unselectedItemColor: navTheme.unselectedItemColor,
          type: navTheme.type ?? BottomNavigationBarType.fixed,
          elevation: navTheme.elevation ?? 0,
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
        ),
      ),
    );
  }
}
