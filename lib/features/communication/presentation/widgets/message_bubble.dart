import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/crypto/symmetric_crypto.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';

class MessageBubble extends ConsumerWidget {
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

  Future<Uint8List?> _resolvePreviewBytes(WidgetRef ref, String attachmentId) async {
    final storage = ref.read(secureStorageProvider);

    final cachedPreview = await storage.read(key: '$attachmentId-attachment-preview');
    if (cachedPreview != null && cachedPreview.trim().isNotEmpty) {
      try {
        final decoded = base64Decode(cachedPreview);
        if (decoded.isNotEmpty) {
          return Uint8List.fromList(decoded);
        }
      } catch (_) {
        // ignore and continue to fetch remote preview
      }
    }

    final metadata = await storage.read(key: '$attachmentId-attachment-meta');
    if (metadata == null || metadata.trim().isEmpty) {
      return null;
    }

    try {
      final decodedMetadata = jsonDecode(metadata);
      if (decodedMetadata is! Map) {
        return null;
      }

      final key = decodedMetadata['key']?.toString().trim();
      final contentType =
          (decodedMetadata['originalContentType'] ?? decodedMetadata['contentType'])
              .toString();
      if (key == null || key.isEmpty || !contentType.toLowerCase().startsWith('image/')) {
        return null;
      }

      final apiClient = ref.read(chatsApiClientProvider);
      final download = await apiClient.getAttachmentDownloadUrl(attachmentId);
      if (download.downloadUrl.trim().isEmpty) {
        return null;
      }

      final response = await Dio().get(
        download.downloadUrl,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      final encryptedBytes = response.data is List<int>
          ? response.data as List<int>
          : const <int>[];
      if (encryptedBytes.isEmpty) {
        return null;
      }

      final decryptedBytes = await ref.read(symmetricCryptoProvider).decryptBytes(
        encryptedBase64: base64Encode(encryptedBytes),
        secretKey: SecretKey(base64Decode(key)),
      );

      await storage.write(
        key: '$attachmentId-attachment-preview',
        value: base64Encode(decryptedBytes),
      );

      return decryptedBytes;
    } catch (_) {
      return null;
    }
  }

  Widget _previewWidget(BuildContext context, WidgetRef ref) {
    final attachmentId = message.attachmentId?.trim();
    if (attachmentId == null || attachmentId.isEmpty) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<Uint8List?>(
      future: _resolvePreviewBytes(ref, attachmentId),
      builder: (context, snapshot) {
        final previewBytes = snapshot.data;
        if (!snapshot.hasData || previewBytes == null || previewBytes.isEmpty) {
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
