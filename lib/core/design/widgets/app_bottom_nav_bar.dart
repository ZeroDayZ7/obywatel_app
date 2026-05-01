import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;
  final Color? backgroundColor;
  final Color? primaryColor; // Zmienione z activeColor na primaryColor

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.primaryColor, // Zmienione tutaj
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Używamy przekazanego primaryColor lub bierzemy z motywu
    final activeCol = primaryColor ?? theme.colorScheme.primary;
    final bg = backgroundColor ?? theme.colorScheme.surface;

    return Container(
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(color: activeCol.withValues(alpha: 0.3), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: activeCol.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: activeCol,
        unselectedItemColor: theme.unselectedWidgetColor.withValues(alpha: 0.6),
        type: BottomNavigationBarType.fixed,
        items: items,
      ),
    );
  }
}
