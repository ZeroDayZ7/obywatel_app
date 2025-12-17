// lib/app/router/extensions/go_router_extensions.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/router_config.dart';

extension GoRouteExtensions on String {
  /// Tworzy GoRoute używając standardowej nawigacji Material.
  /// Obsługuje zagnieżdżone trasy poprzez parametr [routes].
  GoRoute go(Widget screen, {List<GoRoute> routes = const []}) {
    return GoRoute(
      path: this,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: screen,
        // Możesz tu dodać name: this, lub arguments: state.extra jeśli potrzebujesz
      ),
      routes: routes,
    );
  }
}
