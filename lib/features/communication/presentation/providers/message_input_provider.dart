import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mime/mime.dart';
import 'package:obywatel_plus/core/crypto/symmetric_crypto.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/local_attachment_store.dart';
import 'package:obywatel_plus/core/storage/local_attachment_store_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/repositories/chats_repository.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/active_chat_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_input_provider.freezed.dart';
part 'message_input_provider.g.dart';

Dio Function({required String contentType}) attachmentUploadClientFactory =
    ({required String contentType}) => Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) =>
            status != null && status >= 200 && status < 300,
        headers: {'Content-Type': contentType},
      ),
    );

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
    String? preparedAttachmentId,
    String? uploadUrl,
    String? uploadedAttachmentId,
  }) = _MessageInputState;

  const MessageInputState._();

  bool get canSend => text.trim().isNotEmpty || attachment != null;
}

@riverpod
class MessageInput extends _$MessageInput {
  late final ActiveChat _chat;
  late final AppLogger _logger;
  late final ChatsApiClient _apiClient;
  late final SymmetricCrypto _crypto;
  late final SecureStorageService _storage;
  late final LocalAttachmentStore _localAttachmentStore;
  late final ChatsRepository _repository;

  @override
  MessageInputState build(String conversationId) {
    ref.keepAlive();
    _chat = ref.read(activeChatProvider(conversationId).notifier);
    _logger = ref.read(appLoggerProvider);
    _apiClient = ref.read(chatsApiClientProvider);
    _crypto = ref.read(symmetricCryptoProvider);
    _storage = ref.read(secureStorageProvider);
    _localAttachmentStore = ref.read(localAttachmentStoreProvider);
    _repository = ref.read(chatsRepositoryProvider);
    return const MessageInputState();
  }

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
      preparedAttachmentId: null,
      uploadUrl: null,
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
      preparedAttachmentId: null,
      uploadUrl: null,
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
      }

      await _chat.sendMessage(
        content.isEmpty ? '' : content,
        attachmentId: attachmentId,
      );

      state = const MessageInputState();
      return true;
    } catch (error, stackTrace) {
      _logger.e(
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

  Future<Map<String, dynamic>> _preservedAttachmentMetadata({
    required String attachmentId,
    String? preparedAttachmentId,
    String? localFilePath,
    String? thumbnailPath,
    bool hasThumbnail = false,
  }) async {
    String? resolvedLocalFilePath = localFilePath;
    String? resolvedThumbnailPath = thumbnailPath;
    bool resolvedHasThumbnail = hasThumbnail;

    final candidateIds = <String>[];
    final normalizedPrepared = preparedAttachmentId?.trim();
    final normalizedAttachment = attachmentId.trim();
    if (normalizedPrepared != null && normalizedPrepared.isNotEmpty) {
      candidateIds.add(normalizedPrepared);
    }
    if (normalizedAttachment.isNotEmpty) {
      candidateIds.add(normalizedAttachment);
    }

    for (final candidateId in candidateIds) {
      final existingMetadata =
          await _repository.getAttachmentMetadata(candidateId) ??
              const <String, dynamic>{};

      final existingLocalFilePath = existingMetadata['localFilePath']?.toString();
      if ((existingLocalFilePath != null && existingLocalFilePath.trim().isNotEmpty) &&
          (resolvedLocalFilePath == null || resolvedLocalFilePath.trim().isEmpty)) {
        resolvedLocalFilePath = existingLocalFilePath;
      }

      final existingThumbnailPath = existingMetadata['thumbnailPath']?.toString();
      if ((existingThumbnailPath != null && existingThumbnailPath.trim().isNotEmpty) &&
          (resolvedThumbnailPath == null || resolvedThumbnailPath.trim().isEmpty)) {
        resolvedThumbnailPath = existingThumbnailPath;
      }

      if (existingMetadata['hasThumbnail'] == true) {
        resolvedHasThumbnail = true;
      }
    }

    if (resolvedThumbnailPath != null &&
        resolvedThumbnailPath.trim().isNotEmpty) {
      try {
        resolvedHasThumbnail = await File(resolvedThumbnailPath).exists();
      } catch (_) {
        resolvedHasThumbnail = false;
      }
    } else if (resolvedHasThumbnail) {
      resolvedHasThumbnail = false;
    }

    return {
      'localFilePath': resolvedLocalFilePath,
      'thumbnailPath': resolvedThumbnailPath,
      'hasThumbnail': resolvedHasThumbnail,
    };
  }

  Future<String?> _safeSaveAttachment({
    required LocalAttachmentStore localAttachmentStore,
    required String attachmentId,
    required Uint8List bytes,
    required String mimeType,
    String? fileName,
  }) async {
    try {
      return await localAttachmentStore.saveAttachment(
        attachmentId: attachmentId,
        bytes: bytes,
        mimeType: mimeType,
        fileName: fileName,
      );
    } on MissingPluginException {
      _logger.w(
        'Local attachment storage is unavailable; skipping local file persistence for $attachmentId',
        module: 'MessageInputProvider',
      );
      return null;
    }
  }

  Future<String?> _safeSaveThumbnail({
    required LocalAttachmentStore localAttachmentStore,
    required String attachmentId,
    required Uint8List bytes,
  }) async {
    try {
      final thumbnailPath = await localAttachmentStore.thumbnailPathForAttachment(
        attachmentId,
      );
      await localAttachmentStore.saveThumbnail(
        attachmentId: attachmentId,
        bytes: bytes,
      );
      return thumbnailPath;
    } on MissingPluginException {
      _logger.w(
        'Local thumbnail storage is unavailable; skipping thumbnail persistence for $attachmentId',
        module: 'MessageInputProvider',
      );
      return null;
    }
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

    final apiClient = _apiClient;
    final crypto = _crypto;
    final storage = _storage;
    final localAttachmentStore = _localAttachmentStore;
    final repository = _repository;

    final preparedAttachmentId = state.preparedAttachmentId?.trim();
    final preparedUploadUrl = state.uploadUrl?.trim();
    final uploadedAttachmentId = state.uploadedAttachmentId?.trim();

    if (uploadedAttachmentId != null && uploadedAttachmentId.isNotEmpty) {
      return uploadedAttachmentId;
    }

    if (preparedAttachmentId != null &&
        preparedAttachmentId.isNotEmpty &&
        preparedUploadUrl != null &&
        preparedUploadUrl.isNotEmpty) {
      try {
        final keyRef = '$preparedAttachmentId-attachment-key';
        final storedKey = await storage.read(key: keyRef);
        if (storedKey == null || storedKey.trim().isEmpty) {
          state = state.copyWith(
            preparedAttachmentId: null,
            uploadUrl: null,
            errorMessage: 'Nie można wznowić wysyłki załącznika. Spróbuj ponownie.',
          );
          return null;
        }

        final encryptedBase64 = await crypto.encryptBytes(
          clearBytes: pending.bytes,
          secretKey: SecretKey(base64Decode(storedKey)),
        );
        final encryptedBytes = base64Decode(encryptedBase64);
        final encryptedSha256 = sha256.convert(encryptedBytes).toString();

        final uploadClient = attachmentUploadClientFactory(
          contentType: pending.mimeType,
        );

        try {
          await uploadClient.put(
            preparedUploadUrl,
            data: encryptedBytes,
            options: Options(
              headers: {'Content-Type': pending.mimeType},
              followRedirects: false,
            ),
          );
        } catch (putError, putStackTrace) {
          _logger.w(
            'Prepared attachment upload timed out or failed for conversation $conversationId; attempting finalize anyway',
            error: putError,
            stackTrace: putStackTrace,
            module: 'MessageInputProvider',
          );
        }

        final finalAttachment = await apiClient.finalizeAttachmentUpload(
          attachmentId: preparedAttachmentId,
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

        final metadata = await _preservedAttachmentMetadata(
          attachmentId: finalAttachment.id,
          preparedAttachmentId: preparedAttachmentId,
          localFilePath: null,
          thumbnailPath: null,
          hasThumbnail: false,
        );
        await repository.saveAttachmentMetadata(
          attachmentId: finalAttachment.id,
          originalFileName: pending.fileName,
          mimeType: pending.mimeType,
          sizeBytes: pending.bytes.length,
          sha256: encryptedSha256,
          localFilePath: metadata['localFilePath'] as String?,
          thumbnailPath: metadata['thumbnailPath'] as String?,
          status: 'ready',
          isAvailableLocally: true,
          hasThumbnail: metadata['hasThumbnail'] as bool,
        );

        state = state.copyWith(
          preparedAttachmentId: null,
          uploadUrl: null,
          uploadedAttachmentId: finalAttachment.id,
        );
        return finalAttachment.id;
      } catch (error, stackTrace) {
        _logger.e(
          'Attachment upload resume failed for conversation $conversationId',
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

    try {
      final response = await apiClient.prepareAttachmentUpload(
        conversationId: conversationId,
        fileName: pending.fileName,
        contentType: pending.mimeType,
        size: pending.bytes.length,
      );

      final attachmentId = response.attachment.id;
      final attachmentKey = await crypto.generateMasterKey();
      final encryptedBase64 = await crypto.encryptBytes(
        clearBytes: pending.bytes,
        secretKey: attachmentKey,
      );
      final encryptedBytes = base64Decode(encryptedBase64);
      final encryptedSha256 = sha256.convert(encryptedBytes).toString();
      final keyBytes = await attachmentKey.extractBytes();
      final keyRef = '$attachmentId-attachment-key';
      final keyValue = base64Encode(keyBytes);

      await storage.write(key: keyRef, value: keyValue);

      final localFilePath = await _safeSaveAttachment(
        localAttachmentStore: localAttachmentStore,
        attachmentId: attachmentId,
        bytes: pending.bytes,
        mimeType: pending.mimeType,
        fileName: pending.fileName,
      );

      String? thumbnailPath;
      if (pending.isImage) {
        thumbnailPath = await _safeSaveThumbnail(
          localAttachmentStore: localAttachmentStore,
          attachmentId: attachmentId,
          bytes: pending.bytes,
        );
      }

      final uploadMetadata = await _preservedAttachmentMetadata(
        attachmentId: attachmentId,
        preparedAttachmentId: attachmentId,
        localFilePath: localFilePath,
        thumbnailPath: thumbnailPath,
        hasThumbnail: pending.isImage && thumbnailPath != null,
      );
      await repository.saveAttachmentMetadata(
        attachmentId: attachmentId,
        originalFileName: pending.fileName,
        mimeType: pending.mimeType,
        sizeBytes: pending.bytes.length,
        sha256: encryptedSha256,
        localFilePath: uploadMetadata['localFilePath'] as String?,
        thumbnailPath: uploadMetadata['thumbnailPath'] as String?,
        status: 'uploaded',
        isAvailableLocally: true,
        hasThumbnail: uploadMetadata['hasThumbnail'] as bool,
      );

      state = state.copyWith(
        preparedAttachmentId: attachmentId,
        uploadUrl: response.uploadUrl,
        uploadedAttachmentId: null,
      );

      final uploadClient = attachmentUploadClientFactory(
        contentType: pending.mimeType,
      );

      try {
        await uploadClient.put(
          response.uploadUrl,
          data: encryptedBytes,
          options: Options(
            headers: {'Content-Type': pending.mimeType},
            followRedirects: false,
          ),
        );
      } catch (putError, putStackTrace) {
        _logger.w(
          'Attachment upload timed out or failed for conversation $conversationId; attempting finalize anyway',
          error: putError,
          stackTrace: putStackTrace,
          module: 'MessageInputProvider',
        );
      }

      final finalAttachment = await apiClient.finalizeAttachmentUpload(
        attachmentId: attachmentId,
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

      final finalMetadata = await _preservedAttachmentMetadata(
        attachmentId: finalAttachment.id,
        preparedAttachmentId: attachmentId,
        localFilePath: localFilePath,
        thumbnailPath: thumbnailPath,
        hasThumbnail: pending.isImage && thumbnailPath != null,
      );
      await repository.saveAttachmentMetadata(
        attachmentId: finalAttachment.id,
        originalFileName: pending.fileName,
        mimeType: pending.mimeType,
        sizeBytes: pending.bytes.length,
        sha256: encryptedSha256,
        localFilePath: finalMetadata['localFilePath'] as String?,
        thumbnailPath: finalMetadata['thumbnailPath'] as String?,
        status: 'ready',
        isAvailableLocally: true,
        hasThumbnail: finalMetadata['hasThumbnail'] as bool,
      );

      state = state.copyWith(
        preparedAttachmentId: null,
        uploadUrl: null,
        uploadedAttachmentId: finalAttachment.id,
      );
      return finalAttachment.id;
    } catch (error, stackTrace) {
      _logger.e(
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
