// lib/app/router/router_config.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/core/errors/presentation/error_screen.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_refresh_provider.dart';

import 'app_routes.dart';
import 'redirect/redirect_logic.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
GlobalKey<NavigatorState> get rootNavigatorKey => _rootNavigatorKey;

GoRouter createRouter({required Ref ref, required List<GoRoute> routes}) {
  final refreshListenable = ref.watch(authRefreshListenableProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.initial,
    refreshListenable: refreshListenable,
    routes: routes,
    redirect: (context, state) => appRedirectLogic(ref, state),
    errorBuilder: (context, state) {
      debugPrint('⚠️ GoRouter error: ${state.error}');
      return ErrorScreen(state: state);
    },
  );
}
