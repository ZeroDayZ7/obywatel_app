import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/responsive_content_wrapper.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final bool useSafeArea;
  final AlignmentGeometry alignment;
  final bool scrollable;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final ContainerSize size; // NOWOŚĆ

  const AppScaffold({
    super.key,
    required this.child,
    this.useSafeArea = true,
    this.alignment = Alignment.topCenter,
    this.scrollable = true,
    this.backgroundColor,
    this.appBar,
    this.size = ContainerSize.medium, // Domyślnie średni
  });

  @override
  Widget build(BuildContext context) {
    Widget content = scrollable ? SingleChildScrollView(child: child) : child;

    content = ResponsiveContainer(
      alignment: alignment,
      size: size, // PRZEKAZUJEMY ROZMIAR TUTAJ
      child: content,
    );

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      body: content,
    );
  }
}
