import 'package:flutter/material.dart';

class AppBadge extends StatelessWidget {
  final int count;
  final Widget child;
  final bool showBadge;

  const AppBadge({
    super.key,
    required this.count,
    required this.child,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showBadge || count <= 0) return child;

    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -7,
          right: -7,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: count > 9 ? 6 : 4,
              vertical: 2,
            ),
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: theme.colorScheme.surface, width: 2),
            ),
            child: Center(
              child: Text(
                count > 99 ? '99+' : '$count',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onError,
                  height: 1,
                  fontFamily: theme.textTheme.labelSmall?.fontFamily,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
