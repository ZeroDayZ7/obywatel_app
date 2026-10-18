import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messages/date_divider.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messages/message_bubble.dart';

class MessageList extends StatelessWidget {
  final List<Message> messages;
  final ScrollController? controller;

  const MessageList({super.key, required this.messages, this.controller});

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
      controller: controller,
      reverse: false,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final previousMessage = index > 0 ? messages[index - 1] : null;

        final showDivider = _shouldShowDateDivider(message, previousMessage);

        return Column(
          key: ValueKey('message-list-row-${message.id}'),
          children: [
            if (showDivider)
              DateDivider(
                key: ValueKey('date-divider-${message.id}'),
                date: message.createdAt,
              ),
            MessageBubble(key: ValueKey(message.id), message: message),
          ],
        );
      },
    );
  }
}
