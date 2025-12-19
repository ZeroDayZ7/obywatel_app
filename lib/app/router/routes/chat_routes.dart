// chat_routes.dart
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/router/extensions/go_router_extensions.dart';
import 'package:obywatel_plus/features/chat/presentation/screens/chat_screen.dart';

final chatRoutes = [AppRoutes.chats.go(const ChatScreen())];
