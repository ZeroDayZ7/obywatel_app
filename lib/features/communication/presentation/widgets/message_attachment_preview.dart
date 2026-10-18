import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/message_input_provider.dart';

class MessageAttachmentPreview extends StatelessWidget {
  const MessageAttachmentPreview({
    super.key,
    required this.attachment,
    required this.isSending,
    required this.onRemove,
  });

  final PendingAttachment attachment;
  final bool isSending;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 320),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (attachment.isImage)
                SizedBox(
                  width: 72,
                  height: 72,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: Image.memory(
                      attachment.bytes,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                SizedBox(
                  width: 72,
                  height: 72,
                  child: Icon(
                    Icons.insert_drive_file_rounded,
                    color: colorScheme.primary,
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attachment.fileName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        attachment.isImage
                            ? 'Zdjęcie'
                            : attachment.mimeType,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: isSending ? null : onRemove,
                icon: const Icon(Icons.close_rounded),
                tooltip: 'Usuń załącznik',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
