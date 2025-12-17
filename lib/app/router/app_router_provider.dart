// lib/app/router/app_router_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'router_config.dart';
import 'routes/all_routes.dart';

// Eksportujemy klucz, aby app_toast.dart mógł go widzieć (rozwiązuje błąd importu)
export 'router_config.dart' show rootNavigatorKey;

final appRouterProvider = Provider<GoRouter>((ref) {
  // 1. Pobieramy wszystkie trasy z modułów
  final routes = getAllRoutes();

  // 2. Tworzymy i zwracamy router
  return createRouter(ref: ref, routes: routes);
});
