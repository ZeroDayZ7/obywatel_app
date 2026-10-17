import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mime/mime.dart';
import 'package:obywatel_plus/core/crypto/symmetric_crypto.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/local_attachment_store_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/active_chat_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_input_provider.freezed.dart';
part 'message_input_provider.g.dart';

@freezed
abstract class PendingAttachment with _$PendingAttachment {
  const factory PendingAttachment({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
    String? filePath,
    @Default(false) bool isImage,
  }) = _PendingAttachment;
}

@freezed
abstract class MessageInputState with _$MessageInputState {
  const factory MessageInputState({
    @Default('') String text,
    PendingAttachment? attachment,
    @Default(false) bool isSending,
    String? errorMessage,
    String? uploadedAttachmentId,
  }) = _MessageInputState;

  const MessageInputState._();

  bool get canSend => text.trim().isNotEmpty || attachment != null;
}

@riverpod
class MessageInput extends _$MessageInput {
  @override
  MessageInputState build(String conversationId) => const MessageInputState();

  void updateText(String text) {
    if (state.isSending) return;
    state = state.copyWith(text: text, errorMessage: null);
  }

  void clear() {
    if (state.isSending) return;
    state = const MessageInputState();
  }

  void clearAttachment() {
    if (state.isSending) return;
    state = state.copyWith(
      attachment: null,
      uploadedAttachmentId: null,
      errorMessage: null,
    );
  }

  Future<void> setAttachmentSelection({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
    String? filePath,
    bool? isImage,
  }) async {
    if (state.isSending) {
      return;
    }

    final resolvedMimeType = mimeType.trim().isNotEmpty
        ? mimeType
        : (lookupMimeType(filePath ?? fileName) ?? 'application/octet-stream');
    final validationError = _validateAttachment(
      fileName: fileName,
      bytes: bytes,
      mimeType: resolvedMimeType,
    );
    if (validationError != null) {
      state = state.copyWith(
        attachment: null,
        errorMessage: validationError,
      );
      return;
    }

    final effectiveIsImage = isImage ?? _looksLikeImage(fileName, resolvedMimeType);
    state = state.copyWith(
      attachment: PendingAttachment(
        fileName: fileName.trim(),
        bytes: Uint8List.fromList(bytes),
        mimeType: resolvedMimeType,
        filePath: filePath,
        isImage: effectiveIsImage,
      ),
      uploadedAttachmentId: null,
      errorMessage: null,
    );
  }

  Future<bool> sendCurrentMessage() async {
    final hasAttachment = state.attachment != null;
    final content = state.text.trim();
    if (content.isEmpty && !hasAttachment) {
      return false;
    }

    if (state.isSending) {
      return false;
    }

    state = state.copyWith(isSending: true, errorMessage: null);

    try {
      String? attachmentId = state.uploadedAttachmentId;
      if (hasAttachment && (attachmentId == null || attachmentId.trim().isEmpty)) {
        attachmentId = await _uploadPendingAttachment(state.attachment!);
        if (attachmentId == null) {
          state = state.copyWith(isSending: false);
          return false;
        }
        state = state.copyWith(uploadedAttachmentId: attachmentId);
      }

      await ref
          .read(activeChatProvider(conversationId).notifier)
          .sendMessage(content.isEmpty ? '' : content, attachmentId: attachmentId);

      state = const MessageInputState();
      return true;
    } catch (error, stackTrace) {
      ref
          .read(appLoggerProvider)
          .e(
            'Message send failed for conversation $conversationId',
            error: error,
            stackTrace: stackTrace,
            module: 'MessageInputProvider',
          );

      state = state.copyWith(
        isSending: false,
        errorMessage: 'Nie udało się wysłać wiadomości. Spróbuj ponownie.',
      );
      return false;
    }
  }

  String? _validateAttachment({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
  }) {
    final normalizedName = fileName.trim();
    if (normalizedName.isEmpty) {
      return 'Nazwa pliku jest wymagana.';
    }
    if (bytes.isEmpty) {
      return 'Wybrany plik jest pusty.';
    }
    if (bytes.length > 25 * 1024 * 1024) {
      return 'Plik jest za duży. Maksymalnie 25 MB.';
    }
    if (mimeType.trim().isEmpty) {
      return 'Nie udało się rozpoznać typu pliku.';
    }
    return null;
  }

  bool _looksLikeImage(String fileName, String mimeType) {
    final normalized = fileName.toLowerCase();
    final mediaType = mimeType.toLowerCase();
    return mediaType.startsWith('image/') ||
        normalized.endsWith('.png') ||
        normalized.endsWith('.jpg') ||
        normalized.endsWith('.jpeg') ||
        normalized.endsWith('.gif') ||
        normalized.endsWith('.webp');
  }

  Future<String?> _uploadPendingAttachment(PendingAttachment pending) async {
    final validationError = _validateAttachment(
      fileName: pending.fileName,
      bytes: pending.bytes,
      mimeType: pending.mimeType,
    );
    if (validationError != null) {
      state = state.copyWith(
        attachment: null,
        errorMessage: validationError,
      );
      return null;
    }

    try {
      final apiClient = ref.read(chatsApiClientProvider);
      final crypto = ref.read(symmetricCryptoProvider);
      final storage = ref.read(secureStorageProvider);
      final localAttachmentStore = ref.read(localAttachmentStoreProvider);
      final repository = ref.read(chatsRepositoryProvider);

      final response = await apiClient.prepareAttachmentUpload(
        conversationId: conversationId,
        fileName: pending.fileName,
        contentType: pending.mimeType,
        size: pending.bytes.length,
      );

      final attachmentKey = await crypto.generateMasterKey();
      final encryptedBase64 = await crypto.encryptBytes(
        clearBytes: pending.bytes,
        secretKey: attachmentKey,
      );
      final encryptedBytes = base64Decode(encryptedBase64);
      final encryptedSha256 = sha256.convert(encryptedBytes).toString();
      final keyBytes = await attachmentKey.extractBytes();
      final keyRef = '${response.attachment.id}-attachment-key';
      final keyValue = base64Encode(keyBytes);

      await storage.write(key: keyRef, value: keyValue);
      await repository.saveAttachmentMetadata(
        attachmentId: response.attachment.id,
        originalFileName: pending.fileName,
        mimeType: pending.mimeType,
        sizeBytes: pending.bytes.length,
        sha256: encryptedSha256,
        localFilePath: null,
        thumbnailPath: null,
        status: 'uploaded',
        isAvailableLocally: true,
        hasThumbnail: false,
      );

      final localFilePath = await localAttachmentStore.saveAttachment(
        attachmentId: response.attachment.id,
        bytes: pending.bytes,
        mimeType: pending.mimeType,
        fileName: pending.fileName,
      );

      if (pending.isImage) {
        final thumbnailPath = await localAttachmentStore.thumbnailPathForAttachment(
          response.attachment.id,
        );
        await localAttachmentStore.saveThumbnail(
          attachmentId: response.attachment.id,
          bytes: pending.bytes,
        );
        await repository.saveAttachmentMetadata(
          attachmentId: response.attachment.id,
          originalFileName: pending.fileName,
          mimeType: pending.mimeType,
          sizeBytes: pending.bytes.length,
          sha256: encryptedSha256,
          localFilePath: localFilePath,
          thumbnailPath: thumbnailPath,
          status: 'ready',
          isAvailableLocally: true,
          hasThumbnail: true,
        );
      } else {
        await repository.saveAttachmentMetadata(
          attachmentId: response.attachment.id,
          originalFileName: pending.fileName,
          mimeType: pending.mimeType,
          sizeBytes: pending.bytes.length,
          sha256: encryptedSha256,
          localFilePath: localFilePath,
          thumbnailPath: null,
          status: 'ready',
          isAvailableLocally: true,
          hasThumbnail: false,
        );
      }

      final uploadClient = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          validateStatus: (status) =>
              status != null && status >= 200 && status < 300,
          headers: {'Content-Type': pending.mimeType},
        ),
      );

      await uploadClient.put(
        response.uploadUrl,
        data: encryptedBytes,
        options: Options(
          headers: {'Content-Type': pending.mimeType},
          followRedirects: false,
        ),
      );

      final finalAttachment = await apiClient.finalizeAttachmentUpload(
        attachmentId: response.attachment.id,
        size: pending.bytes.length,
        sha256: encryptedSha256,
        metadata: {
          'version': 1,
          'ciphertextAlgorithm': 'AES-256-GCM',
          'keyRef': keyRef,
          'keyStoredLocally': true,
          'originalContentType': pending.mimeType,
          'originalFilename': pending.fileName,
        },
      );

      return finalAttachment.id;
    } catch (error, stackTrace) {
      ref
          .read(appLoggerProvider)
          .e(
            'Attachment upload failed for conversation $conversationId',
            error: error,
            stackTrace: stackTrace,
            module: 'MessageInputProvider',
          );

      state = state.copyWith(
        isSending: false,
        errorMessage: 'Nie udało się wysłać załącznika. Spróbuj ponownie.',
      );
      return null;
    }
  }
}
