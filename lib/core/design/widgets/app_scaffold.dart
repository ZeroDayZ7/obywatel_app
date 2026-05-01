import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/responsive_content_wrapper.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final Widget? drawer;
  final bool useSafeArea;
  final AlignmentGeometry alignment;
  final bool scrollable;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final Widget? title;
  final List<Widget>? actions;
  final ContainerSize size;
  final EdgeInsetsGeometry? padding;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const AppScaffold({
    super.key,
    required this.child,
    this.drawer,
    this.useSafeArea = true,
    this.alignment = Alignment.topCenter,
    this.scrollable = true,
    this.backgroundColor,
    this.appBar,
    this.title,
    this.actions,
    this.size = ContainerSize.medium,
    this.padding,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget? effectiveAppBar =
        appBar ??
        (title != null
            ? AppBar(title: title, centerTitle: true, actions: actions)
            : null);

    Widget content = scrollable ? SingleChildScrollView(child: child) : child;

    content = ResponsiveContainer(
      alignment: alignment,
      size: size,
      padding: padding,
      child: content,
    );

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return Scaffold(
      appBar: effectiveAppBar,
      drawer: drawer,
      backgroundColor: backgroundColor,
      body: content,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
