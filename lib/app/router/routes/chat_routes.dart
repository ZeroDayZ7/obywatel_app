import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/features/chat/presentation/screens/chat_groups_screen.dart';
import 'package:obywatel_plus/features/chat/presentation/screens/chat_screen.dart';
import 'package:obywatel_plus/features/chat/presentation/screens/chat_settings_screen.dart';
import 'package:obywatel_plus/features/chat/presentation/screens/chat_shell_wrapper.dart';

final List<RouteBase> chatRoutes = [
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return ChatShellWrapper(navigationShell: navigationShell);
    },
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.chats,
            builder: (context, state) => const ChatScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.chatGroups,
            builder: (context, state) => const ChatGroupsScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: AppRoutes.chatSettings,
            builder: (context, state) => const ChatSettingsScreen(),
          ),
        ],
      ),
    ],
  ),
];
