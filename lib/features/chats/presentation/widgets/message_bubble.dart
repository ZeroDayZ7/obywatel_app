import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/chats/domain/models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMine = message.isMine;

    final bubbleColor = isMine
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHigh;
    final textColor = isMine ? colorScheme.onPrimaryContainer : colorScheme.onSurface;
    final accentColor = isMine ? colorScheme.primary : colorScheme.outline;

    final formattedTime =
        '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}';

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.76,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  message.isEncrypted ? Icons.lock_outline_rounded : Icons.lock_open_rounded,
                  size: 12,
                  color: accentColor,
                ),
                const SizedBox(width: 6),
                Text(
                  isMine ? 'OUTBOUND / Signal' : 'INBOUND / Signal',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: accentColor,
                    letterSpacing: 0.4,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              message.content,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formattedTime,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: textColor.withValues(alpha: 0.7),
                    fontSize: 10,
                  ),
                ),
                if (isMine) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.done_all_rounded,
                    size: 12,
                    color: textColor.withValues(alpha: 0.75),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
