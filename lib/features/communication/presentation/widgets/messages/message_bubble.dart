import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/attachment_preview_provider.dart';
import 'package:obywatel_plus/features/communication/presentation/screens/attachment_viewer_screen.dart';

class MessageBubble extends ConsumerWidget {
  const MessageBubble({super.key, required this.message});

  final Message message;

  bool _looksLikeImage(String? contentType, String? fileName) {
    final normalizedContentType = (contentType ?? '').trim().toLowerCase();
    if (normalizedContentType.startsWith('image/')) {
      return true;
    }

    final normalizedFileName = (fileName ?? '').trim().toLowerCase();
    return normalizedFileName.endsWith('.png') ||
        normalizedFileName.endsWith('.jpg') ||
        normalizedFileName.endsWith('.jpeg') ||
        normalizedFileName.endsWith('.gif') ||
        normalizedFileName.endsWith('.webp') ||
        normalizedFileName.endsWith('.bmp') ||
        normalizedFileName.endsWith('.heic') ||
        normalizedFileName.endsWith('.heif');
  }

  // Zwracamy treść tylko wtedy, gdy użytkownik wpisał własny tekst (podpis),
  // a nie wygenerowaną nazwę pliku.
  String get _displayContent {
    final content = message.content.trim();
    if (content.isNotEmpty) {
      // Jeśli treść to znacznik załącznika lub sama nazwa pliku/ścieżka, nie traktujemy tego jako tekst wiadomości
      if (content.startsWith('📎') || content == 'Załącznik') {
        return '';
      }
      return content;
    }
    return '';
  }

  Widget _fileCard(BuildContext context, String fileName, String mimeType) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final normalizedFileName = fileName.trim();
    final normalizedMimeType = mimeType.trim();

    return GestureDetector(
      onTap: () {
        final attachmentId = message.attachmentId?.trim();
        if (attachmentId == null || attachmentId.isEmpty) {
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => AttachmentViewerScreen(
              attachmentId: attachmentId,
            ),
          ),
        );
      },
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.insert_drive_file_rounded,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    normalizedFileName.isNotEmpty ? normalizedFileName : 'Załącznik',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    normalizedMimeType.isNotEmpty ? normalizedMimeType : 'plik',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _previewWidget(BuildContext context, WidgetRef ref) {
    final attachmentId = message.attachmentId?.trim();
    if (attachmentId == null || attachmentId.isEmpty) {
      return const SizedBox.shrink();
    }

    final metadataAsync = ref.watch(attachmentMetadataProvider(attachmentId));
    final previewAsync = ref.watch(attachmentPreviewProvider(attachmentId));
    final metadata = switch (metadataAsync) {
      AsyncData(:final value) => value ?? const <String, dynamic>{},
      _ => const <String, dynamic>{},
    };
    final contentType =
        (metadata['contentType'] ?? metadata['originalContentType'] ?? '')
            .toString();
    final fileName =
        (metadata['fileName'] ?? metadata['originalFilename'] ?? attachmentId)
            .toString();

    return previewAsync.when(
      data: (previewBytes) {
        final isImage =
            ((previewBytes != null && previewBytes.isNotEmpty) ||
                _looksLikeImage(contentType, fileName));

        if (isImage) {
          if (previewBytes == null || previewBytes.isEmpty) {
            return const SizedBox(
              width: 220,
              child: ListTile(
                dense: true,
                leading: Icon(Icons.broken_image_outlined),
                title: Text('Nie udało się wyświetlić załącznika'),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (_) => AttachmentViewerScreen(
                      attachmentId: attachmentId,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 240,
                    maxHeight: 260,
                  ),
                  child: Image.memory(
                    previewBytes,
                    fit: BoxFit.contain,
                    gaplessPlayback: true,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        width: 220,
                        height: 120,
                        child: Center(child: Icon(Icons.broken_image_outlined)),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        }

        return _fileCard(context, fileName, contentType);
      },
      error: (error, stackTrace) {
        final isImage = _looksLikeImage(contentType, fileName);
        if (isImage) {
          return const SizedBox(
            width: 220,
            child: ListTile(
              dense: true,
              leading: Icon(Icons.broken_image_outlined),
              title: Text('Nie udało się wyświetlić załącznika'),
            ),
          );
        }

        return _fileCard(context, fileName, contentType);
      },
      loading: () {
        final isImage = _looksLikeImage(contentType, fileName);
        if (isImage) {
          return const SizedBox(
            width: 220,
            height: 120,
            child: Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        return _fileCard(context, fileName, contentType);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    final displayText = _displayContent;

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
              _previewWidget(context, ref),
              if (displayText.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  displayText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    height: 1.35,
                  ),
                ),
              ],
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