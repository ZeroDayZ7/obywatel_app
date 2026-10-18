import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/communication/domain/chats/conversation.dart';

class ConversationAvatar extends StatelessWidget {
  final Conversation conversation;

  const ConversationAvatar({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Icon(
        conversation.type == 'group'
            ? Icons.group_outlined
            : Icons.person_outline,
        color: colorScheme.onSurface,
        size: 20,
      ),
    );
  }
}
