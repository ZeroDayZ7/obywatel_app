import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final ContainerSize size;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.size = ContainerSize.medium,
    this.alignment = Alignment.topCenter,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    double getMaxWidth() {
      switch (size) {
        case ContainerSize.compact:
          return 320.0;
        case ContainerSize.narrow:
          return 420.0;
        case ContainerSize.form:
          return 550.0;
        case ContainerSize.medium:
          return 750.0;
        case ContainerSize.reading:
          return 900.0;
        case ContainerSize.wide:
          return 1150.0;
        case ContainerSize.full:
          return double.infinity;
      }
    }

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: getMaxWidth()),
        child: Padding(
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: child,
        ),
      ),
    );
  }
}
