// lib/app/router/app_router_provider.dart
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/router_config.dart';
import 'package:obywatel_plus/app/router/routes/all_routes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router_provider.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // 1. Pobieramy wszystkie trasy z modułów
  final routes = getAllRoutes();

  // 2. Tworzymy i zwracamy router
  return createRouter(ref: ref, routes: routes);
}
