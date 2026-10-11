import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/features/communication/presentation/pages/chat_room_screen.dart';
import 'package:obywatel_plus/features/communication/presentation/pages/communication_screen.dart';

final List<RouteBase> chatRoutes = [
  // Redirect main /chats to CommunicationScreen (tab=0)
  AppRoutes.chats.go(const CommunicationScreen(initialIndex: 0)),

  // Pokój pojedynczego czatu (keep exact route)
  GoRoute(
    path: '/chats/:id',
    builder: (context, state) {
      final conversationId = state.pathParameters['id']!;
      final title = state.extra as String? ?? 'Czat';

      return ChatRoomScreen(conversationId: conversationId, title: title);
    },
  ),
];
