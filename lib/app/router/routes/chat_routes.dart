import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/builders/shell_route_builder.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/features/chat/presentation/pages/chat_groups_screen.dart';
import 'package:obywatel_plus/features/chat/presentation/pages/chat_screen.dart';
import 'package:obywatel_plus/features/chat/presentation/pages/chat_settings_screen.dart';
import 'package:obywatel_plus/features/chat/presentation/widgets/chat_screen/chat_bottom_nav_bar.dart';

final List<RouteBase> chatRoutes = [
  buildShellRoute(
    titles: AppRoutes.chatTitles,
    navBarBuilder: (index, onTap) =>
        ChatBottomNavBar(currentIndex: index, onTap: onTap),
    branchRoutes: [
      [
        AppRoutes.chats.go(const ChatScreen()),
      ],
      [
        AppRoutes.chatGroups.go(const ChatGroupsScreen()),
      ],
      [
        AppRoutes.chatSettings.go(const ChatSettingsScreen()),
      ],
    ],
  ),
];