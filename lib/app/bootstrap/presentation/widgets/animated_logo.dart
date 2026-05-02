import 'package:flutter/material.dart';

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    // final colorScheme = theme.colorScheme;

    return Center(
      // --- OPCJA 1: IKONA (Obecnie aktywna) ---
      // child: AppGlowIcon(
      //   icon: Icons.account_circle,
      //   color: colorScheme.primary,
      //   size: 180,
      //   iconSize: 100,
      // ),

      // --- OPCJA 2: ZDJĘCIE PNG (Zakomentowana) ---
      child: Image.asset(
        'assets/images/logo.png',
        width: 280,
        height: 220,
        fit: BoxFit.contain,
      ),
    );
  }
}
