// lib/app/router/routes/evoting_routes.dart
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/features/evoting/presentation/pages/evoting_screen.dart';

final eVotingRoutes = [
  GoRoute(
    path: AppRoutes.eVoting,
    builder: (context, state) => const EVotingScreen(),
  ),
];