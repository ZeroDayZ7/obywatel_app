import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/core/design/widgets/app_shell_wrapper.dart';

StatefulShellRoute buildShellRoute({
  required List<String> titles,
  required Widget Function(int index, void Function(int) onTap) navBarBuilder,
  required List<List<GoRoute>> branchRoutes,
}) {
  return StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return AppShellWrapper(
        navigationShell: navigationShell,
        titles: titles,
        navBarBuilder: navBarBuilder,
      );
    },
    branches: branchRoutes
        .map((routes) => StatefulShellBranch(routes: routes))
        .toList(),
  );
}
