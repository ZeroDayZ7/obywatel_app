import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/chat/domain/message.dart';
import 'package:obywatel_plus/features/chat/presentation/widgets/user_chat/user_chat_app_bar.dart';
import 'package:obywatel_plus/features/chat/presentation/widgets/user_chat/message_list.dart';
import 'package:obywatel_plus/features/chat/presentation/widgets/user_chat/message_input_field.dart';

class UserChatScreen extends StatefulWidget {
  final String username;

  const UserChatScreen({super.key, required this.username});

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final List<Message> messages = [
    Message(
      id: '1',
      chatId: 'local',
      senderId: 'me',
      text: 'Cześć! Jak się masz?',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isMe: true,
      status: MessageStatus.read,
      imageUrl: null,
    ),
    Message(
      id: '2',
      chatId: 'local',
      senderId: 'user2',
      text: 'Hej! Wszystko dobrze, a u Ciebie?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 55)),
      isMe: false,
      status: MessageStatus.read,
      imageUrl: null,
    ),
  ];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage({String? imageUrl}) {
    final text = _controller.text.trim();

    if (text.isEmpty && imageUrl == null) return;

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: 'local',
      senderId: 'me',
      text: text,
      timestamp: DateTime.now(),
      isMe: true,
      status: MessageStatus.sent,
      imageUrl: imageUrl,
    );

    setState(() {
      messages.add(newMessage);
    });

    _controller.clear();

    // auto-scroll
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: UserChatAppBar(username: widget.username),
      body: Column(
        children: [
          Expanded(
            child: MessageList(
              messages: messages,
              controller: _scrollController,
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          MessageInputField(controller: _controller, onSend: _sendMessage),
        ],
      ),
    );
  }
}
