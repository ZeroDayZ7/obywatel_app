import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/crypto/symmetric_crypto.dart';
import 'package:obywatel_plus/core/storage/local_attachment_store_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';

class MessageBubble extends ConsumerStatefulWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  ConsumerState<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends ConsumerState<MessageBubble> {
  static final Map<String, Future<Uint8List?>> _inFlightDownloads =
      <String, Future<Uint8List?>>{};

  static final Map<String, Future<Uint8List?>> _completedDownloads =
      <String, Future<Uint8List?>>{};

  late Future<Uint8List?> _previewFuture;

  String get _displayContent {
    final content = widget.message.content.trim();
    if (content.isNotEmpty) return content;
    if (widget.message.attachmentId != null &&
        widget.message.attachmentId!.trim().isNotEmpty) {
      return '📎 Załącznik';
    }
    return 'Nie można odszyfrować wiadomości';
  }

  @override
  void initState() {
    super.initState();
    _initPreviewFuture();
  }

  @override
  void didUpdateWidget(covariant MessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message.attachmentId != widget.message.attachmentId) {
      _initPreviewFuture();
    }
  }

  void _initPreviewFuture() {
    final attachmentId = widget.message.attachmentId?.trim();
    if (attachmentId != null && attachmentId.isNotEmpty) {
      _previewFuture = _resolvePreviewBytes(ref, attachmentId);
    } else {
      _previewFuture = Future.value(null);
    }
  }

  Future<Uint8List?> _resolvePreviewBytes(WidgetRef ref, String attachmentId) {
    final completed = _completedDownloads[attachmentId];
    if (completed != null) {
      return completed;
    }

    final existing = _inFlightDownloads[attachmentId];
    if (existing != null) {
      return existing;
    }

    final future = _loadPreviewBytes(ref, attachmentId).then((value) {
      if (value != null && value.isNotEmpty) {
        _completedDownloads[attachmentId] = Future.value(value);
      }
      return value;
    });

    _inFlightDownloads[attachmentId] = future;

    return future.whenComplete(() {
      if (identical(_inFlightDownloads[attachmentId], future)) {
        _inFlightDownloads.remove(attachmentId);
      }
    });
  }

  Future<Uint8List?> _loadPreviewBytes(
    WidgetRef ref,
    String attachmentId,
  ) async {
    final storage = ref.read(secureStorageProvider);
    final localAttachmentStore = ref.read(localAttachmentStoreProvider);
    final repository = ref.read(chatsRepositoryProvider);

    debugPrint(
      '[ATTACHMENT-DIAG] Rozpoczęto ładowanie podglądu dla attachmentId=$attachmentId',
    );

    // 1. Sprawdzenie cache miniatur
    final cachedThumbnail = await localAttachmentStore.readThumbnail(
      attachmentId,
    );
    if (cachedThumbnail != null && cachedThumbnail.isNotEmpty) {
      debugPrint(
        '[ATTACHMENT-DIAG] attachment_id=$attachmentId obsłużony z cache miniatur',
      );
      return cachedThumbnail;
    }

    // 2. Pobranie metadanych
    final metadata = await repository.getAttachmentMetadata(attachmentId);
    if (metadata == null || metadata.isEmpty) {
      debugPrint(
        '[ATTACHMENT-DIAG] BŁĄD: attachment_id=$attachmentId - brak metadanych w repozytorium! Sprawdź czy ChatsRepository poprawnie zapisuje metadane z payloadu E2EE.',
      );
      return null;
    }
    debugPrint(
      '[ATTACHMENT-DIAG] Pobrano metadane dla $attachmentId: $metadata',
    );

    try {
      // 3. Sprawdzenie klucza deszyfrującego
      final key = await storage.read(key: '$attachmentId-attachment-key');
      if (key == null || key.isEmpty) {
        debugPrint(
          '[ATTACHMENT-DIAG] BŁĄD: attachment_id=$attachmentId - brak klucza AES w SecureStorage pod kluczem "$attachmentId-attachment-key"!',
        );
      }

      final contentType =
          (metadata['contentType'] ?? metadata['originalContentType'] ?? '')
              .toString();
      final fileName =
          (metadata['fileName'] ?? metadata['originalFilename'] ?? '')
              .toString();

      if (key == null ||
          key.isEmpty ||
          !contentType.toLowerCase().startsWith('image/')) {
        debugPrint(
          '[ATTACHMENT-DIAG] Przerywam: klucz jest pusty lub typ ($contentType) to nie obraz.',
        );
        return null;
      }

      // 4. Sprawdzenie czy plik fizyczny już istnieje lokalnie
      final localFile = await localAttachmentStore.readAttachment(
        attachmentId: attachmentId,
        mimeType: contentType,
        fileName: fileName,
      );
      if (localFile != null && localFile.isNotEmpty) {
        debugPrint(
          '[ATTACHMENT-DIAG] Znaleziono fizyczny plik lokalnie dla $attachmentId',
        );
        await localAttachmentStore.saveThumbnail(
          attachmentId: attachmentId,
          bytes: localFile,
        );
        return localFile;
      }

      // 5. Pobieranie z serwera (MinIO / API)
      debugPrint(
        '[ATTACHMENT-DIAG] Pobieranie URL pobierania z API dla $attachmentId...',
      );
      final apiClient = ref.read(chatsApiClientProvider);
      final download = await apiClient.getAttachmentDownloadUrl(attachmentId);
      final rawUrl = download.downloadUrl.trim();

      if (rawUrl.isEmpty) {
        debugPrint('[ATTACHMENT-DIAG] BŁĄD: Otrzymany downloadUrl jest pusty.');
        return null;
      }

      debugPrint('[ATTACHMENT-DIAG] Pobieranie zaszyfrowanych bajtów z URL...');
      final encryptedBytes = await apiClient.downloadBytes(rawUrl);
      if (encryptedBytes.isEmpty) {
        debugPrint(
          '[ATTACHMENT-DIAG] BŁĄD: Pobrane zaszyfrowane bajty są puste.',
        );
        return null;
      }

      debugPrint(
        '[ATTACHMENT-DIAG] Deszyfrowanie bajtów algorytmem symetrycznym...',
      );
      final decryptedBytes = await ref
          .read(symmetricCryptoProvider)
          .decryptBytes(
            encryptedBase64: base64Encode(encryptedBytes),
            secretKey: SecretKey(base64Decode(key)),
          );

      if (decryptedBytes.isEmpty) {
        debugPrint('[ATTACHMENT-DIAG] BŁĄD: Zdeszyfrowane bajty są puste.');
        return null;
      }

      await localAttachmentStore.saveAttachment(
        attachmentId: attachmentId,
        bytes: decryptedBytes,
        mimeType: contentType,
        fileName: fileName.isNotEmpty ? fileName : attachmentId,
      );
      await localAttachmentStore.saveThumbnail(
        attachmentId: attachmentId,
        bytes: decryptedBytes,
      );

      debugPrint(
        '[ATTACHMENT-DIAG] Sukces! Załącznik pobrany, zdeszyfrowany i zapisały w cache dla $attachmentId',
      );
      return Uint8List.fromList(decryptedBytes);
    } catch (e, st) {
      debugPrint(
        '[ATTACHMENT-DIAG] WYJĄTEK podczas ładowania załącznika $attachmentId: $e\n$st',
      );
      return null;
    }
  }

  Widget _previewWidget(BuildContext context) {
    final attachmentId = widget.message.attachmentId?.trim();
    if (attachmentId == null || attachmentId.isEmpty) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<Uint8List?>(
      future: _previewFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
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

        final previewBytes = snapshot.data;
        if (snapshot.hasError || previewBytes == null || previewBytes.isEmpty) {
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
                  debugPrint(
                    '[ATTACHMENT-SYNC] Image.memory decode error: $error',
                  );
                  return const SizedBox(
                    width: 220,
                    height: 120,
                    child: Center(child: Icon(Icons.broken_image_outlined)),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMine = widget.message.isMine;

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
        '${widget.message.createdAt.hour.toString().padLeft(2, '0')}:${widget.message.createdAt.minute.toString().padLeft(2, '0')}';

    final statusIcon = switch (widget.message.status) {
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
          maxWidth:
              MediaQuery.of(context).size.width *
              0.78, // Naprawiono brakujący '*'
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
