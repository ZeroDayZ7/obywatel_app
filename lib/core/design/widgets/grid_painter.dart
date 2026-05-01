import 'package:flutter/material.dart';

class CyberBackground extends StatelessWidget {
  final Widget child;
  final bool showCorners;

  const CyberBackground({
    super.key,
    required this.child,
    this.showCorners = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.surface,
                    colorScheme.surface.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          if (showCorners) ...[
            Positioned(
              top: 40,
              left: 20,
              child: _Corner(
                isTop: true,
                isLeft: true,
                color: colorScheme.primary,
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: _Corner(
                isTop: true,
                isLeft: false,
                color: colorScheme.primary,
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              child: _Corner(
                isTop: false,
                isLeft: true,
                color: colorScheme.primary,
              ),
            ),
            Positioned(
              bottom: 40,
              right: 20,
              child: _Corner(
                isTop: false,
                isLeft: false,
                color: colorScheme.primary,
              ),
            ),
          ],
          child,
        ],
      ),
    );
  }
}

class _Corner extends StatelessWidget {
  final bool isTop;
  final bool isLeft;
  final Color color;

  const _Corner({
    required this.isTop,
    required this.isLeft,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? BorderSide(color: color.withValues(alpha: 0.5), width: 2)
              : BorderSide.none,
          bottom: !isTop
              ? BorderSide(color: color.withValues(alpha: 0.5), width: 2)
              : BorderSide.none,
          left: isLeft
              ? BorderSide(color: color.withValues(alpha: 0.5), width: 2)
              : BorderSide.none,
          right: !isLeft
              ? BorderSide(color: color.withValues(alpha: 0.5), width: 2)
              : BorderSide.none,
        ),
      ),
    );
  }
}
