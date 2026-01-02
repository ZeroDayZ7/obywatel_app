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
  final Widget? title;
  final ContainerSize size;
  final EdgeInsetsGeometry? padding; // DODANE: Możliwość ustawienia paddingu

  const AppScaffold({
    super.key,
    required this.child,
    this.useSafeArea = true,
    this.alignment = Alignment.topCenter,
    this.scrollable = true,
    this.backgroundColor,
    this.appBar,
    this.title,
    this.size = ContainerSize.medium,
    this.padding, // DODANE
  });

  @override
  Widget build(BuildContext context) {
    // Automatyczny AppBar jeśli podano title
    final PreferredSizeWidget? effectiveAppBar =
        appBar ??
        (title != null ? AppBar(title: title, centerTitle: true) : null);

    // Przewijanie
    Widget content = scrollable ? SingleChildScrollView(child: child) : child;

    // Kontener responsywny z przekazanym paddingiem
    content = ResponsiveContainer(
      alignment: alignment,
      size: size,
      padding: padding, // PRZEKAZUJEMY TUTAJ
      child: content,
    );

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return Scaffold(
      appBar: effectiveAppBar,
      backgroundColor: backgroundColor,
      body: content,
    );
  }
}
