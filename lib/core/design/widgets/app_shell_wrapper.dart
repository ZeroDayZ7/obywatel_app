import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/core/design/widgets/app_bar.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';

class AppShellWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final List<String> titles;
  final Widget Function(int currentIndex, ValueChanged<int> onTap)
  navBarBuilder;

  const AppShellWrapper({
    super.key,
    required this.navigationShell,
    required this.titles,
    required this.navBarBuilder,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        title: titles[navigationShell.currentIndex],
      ),
      bottomNavigationBar: navBarBuilder(navigationShell.currentIndex, _onTap),
      child: navigationShell,
    );
  }
}
