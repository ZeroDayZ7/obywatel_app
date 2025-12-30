// core/widgets/responsive_content_wrapper.dart
import 'package:flutter/material.dart';

class ResponsiveContentWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveContentWrapper({
    super.key,
    required this.child,
    this.maxWidth = 450.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
