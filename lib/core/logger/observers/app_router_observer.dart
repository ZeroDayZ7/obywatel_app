import 'package:flutter/widgets.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

final class AppRouterObserver extends NavigatorObserver {
  final AppLogger _logger;

  AppRouterObserver(this._logger);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logNavigation(route, previousRoute, action: 'PUSH');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _logNavigation(previousRoute, route, action: 'POP');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _logNavigation(newRoute, oldRoute, action: 'REPLACE');
  }

  void _logNavigation(
    Route<dynamic>? currentRoute,
    Route<dynamic>? previousRoute, {
    required String action,
  }) {
    final currentPath = _extractRouteName(currentRoute);
    final previousPath = _extractRouteName(previousRoute);

    _logger.d('[$action] $currentPath (From: $previousPath)', module: 'Router');
  }

  String _extractRouteName(Route<dynamic>? route) {
    if (route == null) return 'none';
    return route.settings.name ??
        route.settings.arguments?.toString() ??
        route.runtimeType.toString();
  }
}
