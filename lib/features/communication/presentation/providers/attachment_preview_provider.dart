import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/crypto/symmetric_crypto.dart';
import 'package:obywatel_plus/core/storage/local_attachment_store_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';

final attachmentPreviewProvider =
    FutureProvider.autoDispose.family<Uint8List?, String>((ref, attachmentId) {
  final normalized = attachmentId.trim();
  if (normalized.isEmpty) {
    return Future.value(null);
  }

  return _AttachmentPreviewLoader(ref).load(normalized);
});

class _AttachmentPreviewLoader {
  const _AttachmentPreviewLoader(this.ref);

  final Ref ref;

  static final Map<String, Future<Uint8List?>> _inFlightDownloads =
      <String, Future<Uint8List?>>{};

  static final Map<String, Future<Uint8List?>> _completedDownloads =
      <String, Future<Uint8List?>>{};

  Future<Uint8List?> load(String attachmentId) {
    final completed = _completedDownloads[attachmentId];
    if (completed != null) {
      return completed;
    }

    final existing = _inFlightDownloads[attachmentId];
    if (existing != null) {
      return existing;
    }

    final future = _loadPreviewBytes(attachmentId).then((value) {
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

  Future<Uint8List?> _loadPreviewBytes(String attachmentId) async {
    final storage = ref.read(secureStorageProvider);
    final localAttachmentStore = ref.read(localAttachmentStoreProvider);
    final repository = ref.read(chatsRepositoryProvider);

    final cachedThumbnail = await localAttachmentStore.readThumbnail(attachmentId);
    if (cachedThumbnail != null && cachedThumbnail.isNotEmpty) {
      return cachedThumbnail;
    }

    final metadata = await repository.getAttachmentMetadata(attachmentId);
    if (metadata == null || metadata.isEmpty) {
      return null;
    }

    try {
      final key = await storage.read(key: '$attachmentId-attachment-key');

      final contentType =
          (metadata['contentType'] ?? metadata['originalContentType'] ?? '')
              .toString();
      final fileName =
          (metadata['fileName'] ?? metadata['originalFilename'] ?? '').toString();

      if (key == null ||
          key.isEmpty ||
          !contentType.toLowerCase().startsWith('image/')) {
        return null;
      }

      final localFile = await localAttachmentStore.readAttachment(
        attachmentId: attachmentId,
        mimeType: contentType,
        fileName: fileName,
      );
      if (localFile != null && localFile.isNotEmpty) {
        await localAttachmentStore.saveThumbnail(
          attachmentId: attachmentId,
          bytes: localFile,
        );
        return localFile;
      }

      final apiClient = ref.read(chatsApiClientProvider);
      final download = await apiClient.getAttachmentDownloadUrl(attachmentId);
      final rawUrl = download.downloadUrl.trim();
      if (rawUrl.isEmpty) {
        return null;
      }

      final encryptedBytes = await apiClient.downloadBytes(rawUrl);
      if (encryptedBytes.isEmpty) {
        return null;
      }

      final decryptedBytes = await ref
          .read(symmetricCryptoProvider)
          .decryptBytes(
            encryptedBase64: base64Encode(encryptedBytes),
            secretKey: SecretKey(base64Decode(key)),
          );

      if (decryptedBytes.isEmpty) {
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

      return localAttachmentStore.readThumbnail(attachmentId);
    } catch (_) {
      return null;
    }
  }
}
