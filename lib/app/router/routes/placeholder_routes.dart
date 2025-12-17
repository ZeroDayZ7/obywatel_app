// placeholder_routes.dart
import 'package:obywatel_plus/app/router/placeholder_screen.dart';
import '../app_routes.dart';
import '../extensions/go_router_extensions.dart';

final placeholderRoutes = [
  AppRoutes.explore.go(const PlaceholderScreen('Odkryj')),
  AppRoutes.store.go(const PlaceholderScreen('Sklep')),
  AppRoutes.health.go(const PlaceholderScreen('Zdrowie')),
  AppRoutes.education.go(const PlaceholderScreen('Edukacja')),
  AppRoutes.games.go(const PlaceholderScreen('Gry')),
  AppRoutes.videos.go(const PlaceholderScreen('Wideo')),
  AppRoutes.favorites.go(const PlaceholderScreen('Ulubione')),
];
