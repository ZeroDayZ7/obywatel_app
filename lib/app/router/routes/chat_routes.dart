import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/features/chats/presentation/screens/chat_room_screen.dart';
import 'package:obywatel_plus/features/chats/presentation/screens/conversations_screen.dart';

final List<RouteBase> chatRoutes = [
  // Główna lista konwersacji (nowy chats)
  AppRoutes.chats.go(const ConversationsScreen()),

  // Pokój pojedynczego czatu
  GoRoute(
    path: '/chats/:id',
    builder: (context, state) {
      final conversationId = state.pathParameters['id']!;
      final title = state.extra as String? ?? 'Czat';

      return ChatRoomScreen(conversationId: conversationId, title: title);
    },
  ),
];
