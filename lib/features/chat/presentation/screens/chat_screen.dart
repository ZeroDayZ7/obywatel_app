import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';
import 'package:obywatel_plus/features/chat/presentation/widgets/chat_screen/bottom_nav_bar.dart';
import 'package:obywatel_plus/features/chat/presentation/widgets/chat_screen/category_tabs.dart';
import 'package:obywatel_plus/features/chat/presentation/widgets/chat_screen/chat_app_bar.dart';
import 'package:obywatel_plus/features/chat/presentation/widgets/chat_screen/chat_list.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _currentIndex = 0;
  String _selectedCategory = 'All';

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
      'category': index % 2 == 0 ? 'Work' : 'Personal',
    },
  );

  List<String> get _categories => ['All', 'Work', 'Personal', 'Groups'];

  @override
  Widget build(BuildContext context) {
    final filteredChats = _selectedCategory == 'All'
        ? _chats
        : _chats
              .where((chat) => chat['category'] == _selectedCategory)
              .toList();

    return AppScaffold(
      size: ContainerSize.medium,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ChatAppBar(),
      ),
      scrollable: false,
      bottomNavigationBar: CyberpunkBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      child: Column(
        children: [
          CategoryTabs(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
          Expanded(child: CyberpunkChatList(chats: filteredChats)),
        ],
      ),
    );
  }
}
