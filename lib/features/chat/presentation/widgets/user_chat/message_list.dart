import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/chat/domain/message.dart';
import 'package:obywatel_plus/features/chat/presentation/widgets/user_chat/message_bubble.dart';
import 'package:obywatel_plus/features/chat/presentation/widgets/user_chat/date_divider.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;
  final ScrollController controller;

  const MessageList({
    super.key,
    required this.messages,
    required this.controller,
  });

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.all(8),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        bool showDateDivider =
            index == 0 ||
            !isSameDay(messages[index - 1].timestamp, message.timestamp);

        return Column(
          children: [
            if (showDateDivider) DateDivider(date: message.timestamp),
            MessageBubble(message: message),
          ],
        );
      },
    );
  }
}
