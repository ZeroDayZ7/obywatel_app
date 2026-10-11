import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/features/communication/presentation/screens/communication_screen.dart';

final List<RouteBase> communicationRoutes = [
  AppRoutes.communication.go(const CommunicationScreen()),
];
