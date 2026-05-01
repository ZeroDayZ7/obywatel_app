// placeholder_routes.dart
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/app/router/placeholder_screen.dart';

final placeholderRoutes = [
  AppRoutes.explore.go(const PlaceholderScreen('Odkryj')),
  AppRoutes.store.go(const PlaceholderScreen('Sklep')),
  AppRoutes.health.go(const PlaceholderScreen('Zdrowie')),
  AppRoutes.education.go(const PlaceholderScreen('Edukacja')),
  AppRoutes.games.go(const PlaceholderScreen('Gry')),
  AppRoutes.videos.go(const PlaceholderScreen('Wideo')),
  AppRoutes.favorites.go(const PlaceholderScreen('Ulubione')),
];
