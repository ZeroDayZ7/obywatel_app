// lib/features/chat/presentation/chat/widgets/chat_list.dart
import 'package:flutter/material.dart';
import 'chat_list_item.dart';
import 'package:go_router/go_router.dart';

class CyberpunkChatList extends StatelessWidget {
  final List<Map<String, dynamic>> chats;

  const CyberpunkChatList({super.key, required this.chats});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: chats.length,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return CyberpunkChatItem(
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
