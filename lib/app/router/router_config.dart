// lib/app/router/router_config.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/redirect/redirect_logic.dart';
import 'package:obywatel_plus/core/errors/presentation/error_screen.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
// import 'package:obywatel_plus/core/logger/observers/app_router_observer.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_refresh_provider.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

GoRouter createRouter({required Ref ref, required List<RouteBase> routes}) {
  final refreshListenable = ref.watch(authRefreshListenableProvider.notifier);
  // final logger = ref.read(appLoggerProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.initial,
    refreshListenable: refreshListenable,
    // observers: [AppRouterObserver(logger)],
    routes: routes,
    redirect: (context, state) => appRedirectLogic(ref, state),
    errorBuilder: (context, state) {
      ref
          .read(appLoggerProvider)
          .e('GoRouter navigation error', error: state.error, module: 'Router');
      return ErrorScreen(state: state);
    },
  );
}
