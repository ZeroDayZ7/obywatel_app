import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension GoRouteExtensions on String {
  GoRoute go(Widget screen, {List<GoRoute> routes = const []}) {
    return GoRoute(
      path: this,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: screen),
      routes: routes,
    );
  }

  GoRoute goWithState(
    Widget Function(GoRouterState state) builder, {
    List<GoRoute> routes = const [],
  }) {
    return GoRoute(
      path: this,
      pageBuilder: (context, state) =>
          MaterialPage(key: state.pageKey, child: builder(state)),
      routes: routes,
    );
  }
}
