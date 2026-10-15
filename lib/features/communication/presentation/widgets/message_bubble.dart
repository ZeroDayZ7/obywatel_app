import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  String get _displayContent {
    final content = message.content.trim();
    if (content.isNotEmpty) return content;
    if (message.attachmentId != null && message.attachmentId!.trim().isNotEmpty) {
      return '📎 Załącznik';
    }
    return 'Nie można odszyfrować wiadomości';
  }

  Widget _previewWidget(BuildContext context) {
    final attachmentId = message.attachmentId?.trim();
    if (attachmentId == null || attachmentId.isEmpty) {
      return const SizedBox.shrink();
    }

    final storage = ProviderScope.containerOf(context, listen: false)
        .read(secureStorageProvider);

    return FutureBuilder<String?>(
      future: storage.read(key: '$attachmentId-attachment-preview'),
      builder: (context, snapshot) {
        final bytesString = snapshot.data?.trim();
        if (!snapshot.hasData || bytesString == null || bytesString.isEmpty) {
          return const SizedBox.shrink();
        }

        try {
          final previewBytes = base64Decode(bytesString);
          if (previewBytes.isEmpty) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 220, maxHeight: 220),
                child: Image.memory(
                  previewBytes,
                  fit: BoxFit.cover,
                  gaplessPlayback: true,
                ),
              ),
            ),
          );
        } catch (_) {
          return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMine = message.isMine;

    final bubbleColor = isMine
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest;
    final textColor = isMine
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurface;
    final metaColor = isMine
        ? colorScheme.onPrimaryContainer.withValues(alpha: 0.8)
        : colorScheme.onSurfaceVariant;

    final formattedTime =
        '${message.createdAt.hour.toString().padLeft(2, '0')}:${message.createdAt.minute.toString().padLeft(2, '0')}';

    final statusIcon = switch (message.status) {
      'failed' => Icons.error_outline_rounded,
      'pending' => Icons.schedule_rounded,
      'sent' => Icons.done_rounded,
      'delivered' => Icons.done_all_rounded,
      'read' => Icons.done_all_rounded,
      _ => Icons.done_all_rounded,
    };

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMine ? 16 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 16),
          ),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.25),
            width: 1,
          ),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _previewWidget(context),
              if (_displayContent.isNotEmpty)
                Text(
                  _displayContent,
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
                      color: metaColor,
                      fontSize: 10,
                    ),
                  ),
                  if (isMine) ...[
                    const SizedBox(width: 8),
                    Icon(statusIcon, size: 12, color: metaColor),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
