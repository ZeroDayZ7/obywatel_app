import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/widgets/app_shell_wrapper.dart';
import 'package:obywatel_plus/features/chat/presentation/pages/chat_groups_screen.dart';
import 'package:obywatel_plus/features/chat/presentation/pages/chat_screen.dart';
import 'package:obywatel_plus/features/chat/presentation/pages/chat_settings_screen.dart';
import 'package:obywatel_plus/features/chat/presentation/widgets/chat_screen/chat_bottom_nav_bar.dart';

final List<RouteBase> chatRoutes = [
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return AppShellWrapper(
        navigationShell: navigationShell,
        titles: AppRoutes.chatTitles,
        navBarBuilder: (index, onTap) =>
            CyberpunkBottomNavBar(currentIndex: index, onTap: onTap),
      );
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
