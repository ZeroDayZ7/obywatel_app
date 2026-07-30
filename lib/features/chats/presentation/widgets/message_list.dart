import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/chats/domain/models/message.dart';
import 'package:obywatel_plus/features/chats/presentation/widgets/date_divider.dart';
import 'package:obywatel_plus/features/chats/presentation/widgets/message_bubble.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;

  const MessageList({super.key, required this.messages});

  bool _shouldShowDateDivider(Message current, Message? previous) {
    if (previous == null) return true;
    final currentDate = DateTime(
      current.createdAt.year,
      current.createdAt.month,
      current.createdAt.day,
    );
    final previousDate = DateTime(
      previous.createdAt.year,
      previous.createdAt.month,
      previous.createdAt.day,
    );
    return currentDate != previousDate;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final previousMessage = index < messages.length - 1
            ? messages[index + 1]
            : null;

        final showDivider = _shouldShowDateDivider(message, previousMessage);

        return Column(
          children: [
            if (showDivider) DateDivider(date: message.createdAt),
            MessageBubble(message: message),
          ],
        );
      },
    );
  }
}
