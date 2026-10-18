import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:obywatel_plus/core/crypto/symmetric_crypto.dart';
import 'package:obywatel_plus/core/storage/local_attachment_store.dart';
import 'package:obywatel_plus/core/storage/local_attachment_store_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'attachment_preview_provider.g.dart';

class AttachmentIntegrityException implements Exception {
  const AttachmentIntegrityException(this.message);

  final String message;

  @override
  String toString() => 'AttachmentIntegrityException: $message';
}

AttachmentIntegrityResult validateAttachmentIntegrity({
  required Uint8List bytes,
  required Map<String, dynamic>? metadata,
}) {
  final rawHash = (metadata?['sha256'] ?? '').toString().trim();
  final rawSize = metadata?['size'];

  if (rawHash.isEmpty) {
    throw const AttachmentIntegrityException(
      'Missing attachment SHA-256 metadata; refusing to trust the file.',
    );
  }

  final expectedHash = rawHash.toLowerCase();
  final actualHash = sha256.convert(bytes).toString();
  if (actualHash != expectedHash) {
    throw AttachmentIntegrityException(
      'Attachment SHA-256 mismatch: expected $expectedHash but got $actualHash.',
    );
  }

  final parsedSize = rawSize is int
      ? rawSize
      : rawSize is num
      ? rawSize.toInt()
      : int.tryParse(rawSize?.toString() ?? '');

  if (parsedSize != null && parsedSize >= 0 && bytes.length != parsedSize) {
    throw AttachmentIntegrityException(
      'Attachment size mismatch: expected $parsedSize bytes but got ${bytes.length} bytes.',
    );
  }

  return AttachmentIntegrityResult(
    expectedHash: expectedHash,
    expectedSize: parsedSize,
    actualSize: bytes.length,
  );
}

class AttachmentIntegrityResult {
  const AttachmentIntegrityResult({
    required this.expectedHash,
    required this.expectedSize,
    required this.actualSize,
  });

  final String expectedHash;
  final int? expectedSize;
  final int actualSize;
}

Future<void> deleteInvalidAttachmentFile({
  required LocalAttachmentStore localAttachmentStore,
  required String attachmentId,
  required String mimeType,
  String? fileName,
}) async {
  try {
    await localAttachmentStore.deleteAttachment(
      attachmentId: attachmentId,
      mimeType: mimeType,
      fileName: fileName,
    );
  } catch (_) {
    // best effort cleanup; we intentionally keep the surface area of the fix small.
  }
}

Future<String?> persistValidatedAttachment({
  required LocalAttachmentStore localAttachmentStore,
  required String attachmentId,
  required Uint8List bytes,
  required String mimeType,
  required Map<String, dynamic>? metadata,
  String? fileName,
}) async {
  validateAttachmentIntegrity(bytes: bytes, metadata: metadata);

  return localAttachmentStore.saveAttachment(
    attachmentId: attachmentId,
    bytes: bytes,
    mimeType: mimeType,
    fileName: fileName,
  );
}

@riverpod
FutureOr<Uint8List?> attachmentPreview(Ref ref, String attachmentId) async {
  final normalized = attachmentId.trim();
  if (normalized.isEmpty) {
    return null;
  }

  return AttachmentPreviewService(ref).loadPreview(normalized);
}

class AttachmentPreviewService {
  AttachmentPreviewService(this._ref);

  final Ref _ref;

  static final Map<String, Future<Uint8List?>> _inFlightDownloads =
      <String, Future<Uint8List?>>{};

  Future<Uint8List?> loadPreview(String attachmentId) {
    final existing = _inFlightDownloads[attachmentId];
    if (existing != null) {
      return existing;
    }

    final future = _loadPreviewBytes(attachmentId);
    _inFlightDownloads[attachmentId] = future;

    return future.whenComplete(() {
      if (identical(_inFlightDownloads[attachmentId], future)) {
        _inFlightDownloads.remove(attachmentId);
      }
    });
  }

  Future<Uint8List?> _loadPreviewBytes(String attachmentId) async {
    final storage = _ref.read(secureStorageProvider);
    final localAttachmentStore = _ref.read(localAttachmentStoreProvider);
    final repository = _ref.read(chatsRepositoryProvider);

    final cachedThumbnail = await localAttachmentStore.readThumbnail(
      attachmentId,
    );
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
          (metadata['fileName'] ?? metadata['originalFilename'] ?? '')
              .toString();

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
        try {
          validateAttachmentIntegrity(bytes: localFile, metadata: metadata);
          await localAttachmentStore.saveThumbnail(
            attachmentId: attachmentId,
            bytes: localFile,
          );

          final thumbnail = await localAttachmentStore.readThumbnail(
            attachmentId,
          );
          if (thumbnail != null && thumbnail.isNotEmpty) {
            return thumbnail;
          }
        } catch (error) {
          await deleteInvalidAttachmentFile(
            localAttachmentStore: localAttachmentStore,
            attachmentId: attachmentId,
            mimeType: contentType,
            fileName: fileName.isNotEmpty ? fileName : attachmentId,
          );
          return null;
        }
      }

      final apiClient = _ref.read(chatsApiClientProvider);
      final download = await apiClient.getAttachmentDownloadUrl(attachmentId);
      final rawUrl = download.downloadUrl.trim();
      if (rawUrl.isEmpty) {
        return null;
      }

      final encryptedBytes = await apiClient.downloadBytes(rawUrl);
      if (encryptedBytes.isEmpty) {
        return null;
      }

      final decryptedBytes = await _ref
          .read(symmetricCryptoProvider)
          .decryptBytes(
            encryptedBase64: base64Encode(encryptedBytes),
            secretKey: SecretKey(base64Decode(key)),
          );

      if (decryptedBytes.isEmpty) {
        return null;
      }

      try {
        validateAttachmentIntegrity(bytes: decryptedBytes, metadata: metadata);
      } on AttachmentIntegrityException catch (error) {
        await deleteInvalidAttachmentFile(
          localAttachmentStore: localAttachmentStore,
          attachmentId: attachmentId,
          mimeType: contentType,
          fileName: fileName.isNotEmpty ? fileName : attachmentId,
        );
        throw Exception(error.message);
      }

      await persistValidatedAttachment(
        localAttachmentStore: _ref.read(localAttachmentStoreProvider),
        attachmentId: attachmentId,
        bytes: decryptedBytes,
        mimeType: contentType,
        metadata: metadata,
        fileName: fileName.isNotEmpty ? fileName : attachmentId,
      );
      await localAttachmentStore.saveThumbnail(
        attachmentId: attachmentId,
        bytes: decryptedBytes,
      );

      final thumbnail = await localAttachmentStore.readThumbnail(attachmentId);
      if (thumbnail != null && thumbnail.isNotEmpty) {
        return thumbnail;
      }

      return null;
    } catch (_) {
      return null;
    }
  }
}
