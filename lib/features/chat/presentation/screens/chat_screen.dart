import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/chat/presentation/widgets/chat_screen/chat_list.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _chats = List.generate(
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

  @override
  Widget build(BuildContext context) {
    return CyberpunkChatList(chats: _chats);
  }
}