import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/margins/screen_margins.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry padding;
  final bool useTopAlignment;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding = ScreenMargins.all,
    this.useTopAlignment = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final effectiveMaxWidth = maxWidth ?? (screenWidth > 800 ? 700 : 450);

    return Align(
      alignment: useTopAlignment ? Alignment.topCenter : Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: effectiveMaxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
