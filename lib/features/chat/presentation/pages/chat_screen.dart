import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/chat/presentation/widgets/chat_screen/chat_list.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> chats = List.generate(
      12,
      (index) => {
        'username': 'User ${index + 1}',
        'lastMessage': [
          'Hey! How are you doing?',
          'See you tomorrow at the meeting',
          'Thanks for the help!',
          'Can you send me that file?',
          'Great work on the project!',
          'Let\'s catch up soon',
          'Did you see the news?',
          'Working on it right now',
          'Perfect, thanks!',
          'Talk later 👋',
        ][index % 10],
        'time': '${12 + index % 12}:${(index * 5) % 60}'.padLeft(2, '0'),
        'unreadCount': index % 4 == 0 ? index + 1 : 0,
        'isOnline': index % 3 == 0,
      },
    );

    return ChatList(chats: chats);
  }
}
