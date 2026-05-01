import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/widgets/ui/glow_icon.dart';

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: AppGlowIcon(
        icon: Icons.account_circle,
        color: colorScheme.primary,
        size: 180,
        iconSize: 100,
      ),
    );
  }
}
