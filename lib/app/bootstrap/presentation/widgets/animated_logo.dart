import 'package:flutter/material.dart';

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      alignment: Alignment.center,
      children: [
        _Ring(size: 180, color: colorScheme.primary, opacity: 0.1),
        _Ring(size: 150, color: colorScheme.secondary, opacity: 0.1),
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.2),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
            gradient: RadialGradient(
              colors: [
                colorScheme.primary.withValues(alpha: 0.4),
                Colors.transparent,
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.account_circle,
              size: 80,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _Ring extends StatelessWidget {
  final double size;
  final Color color;
  final double opacity;

  const _Ring({required this.size, required this.color, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: opacity), width: 2),
      ),
    );
  }
}
