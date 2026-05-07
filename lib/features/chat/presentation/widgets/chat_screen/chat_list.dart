
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/features/chat/presentation/widgets/chat_screen/chat_list_item.dart';

class ChatList extends StatelessWidget {
  final List<Map<String, dynamic>> chats;

  const ChatList({super.key, required this.chats});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ChatItem(
          username: chat['username'] as String,
          lastMessage: chat['lastMessage'] as String,
          time: chat['time'] as String,
          unreadCount: chat['unreadCount'] as int? ?? 0,
          isOnline: chat['isOnline'] as bool? ?? false,
          onTap: () {
            context.push('/chats/${chat['username']}');
          },
        );
      },
    );
  }
}
