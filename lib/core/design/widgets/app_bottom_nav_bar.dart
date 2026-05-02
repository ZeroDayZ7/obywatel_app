import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> items;
  final Color? backgroundColor;
  final Color? primaryColor;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        elevation: 0,
        selectedItemColor: activeCol,
        unselectedItemColor: theme.unselectedWidgetColor.withValues(alpha: 0.6),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),

        items: items,
      ),
    );
  }
}
