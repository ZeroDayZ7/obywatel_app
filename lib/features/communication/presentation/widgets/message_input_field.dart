import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:obywatel_plus/core/crypto/symmetric_crypto.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/local_attachment_store_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/active_chat_provider.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/message_input_provider.dart';

class AttachmentCameraSupport {
  static bool isCameraSupportedOnCurrentPlatform() {
    return Platform.isAndroid || Platform.isIOS;
  }

  static bool isCameraButtonEnabled() => isCameraSupportedOnCurrentPlatform();

  static String cameraTooltip() {
    if (Platform.isWindows) {
      return 'Aparat jest niedostępny na Windows';
    }
    if (Platform.isLinux) {
      return 'Aparat jest niedostępny na Linux';
    }
    return 'Zrób zdjęcie';
  }
}

enum _AttachmentPickerSource { gallery, camera, file }

class MessageInputField extends ConsumerStatefulWidget {
  final String conversationId;

  const MessageInputField({super.key, required this.conversationId});

  @override
  ConsumerState<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends ConsumerState<MessageInputField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isEmojiPickerVisible = false;
  TextSelection? _lastValidSelection;
  _PendingAttachment? _pendingAttachment;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _controller.addListener(_syncSelection);
  }

  @override
  void dispose() {
    _controller.removeListener(_syncSelection);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _syncSelection() {
    final selection = _controller.selection;
    if (selection.isValid) {
      _lastValidSelection = selection;
    }
  }

  void _updateTextState(String value) {
    ref
        .read(messageInputProvider(widget.conversationId).notifier)
        .updateText(value);
  }

  void _closeEmojiPicker() {
    if (!_isEmojiPickerVisible) {
      return;
    }

    setState(() {
      _isEmojiPickerVisible = false;
    });
  }

  void _insertEmoji(String emoji) {
    final text = _controller.text;
    final selection = _controller.selection.isValid
        ? _controller.selection
        : (_lastValidSelection ?? TextSelection.collapsed(offset: text.length));

    final start = selection.start.clamp(0, text.length);
    final end = selection.end.clamp(start, text.length);

    final newText = text.replaceRange(start, end, emoji);
    final newSelection = TextSelection.collapsed(
      offset: start + emoji.length,
      affinity: selection.affinity,
    );

    _controller.value = TextEditingValue(
      text: newText,
      selection: newSelection,
      composing: TextRange.empty,
    );
    _lastValidSelection = newSelection;
    _updateTextState(newText);
  }

  void _toggleEmojiPicker() {
    if (_isEmojiPickerVisible) {
      _closeEmojiPicker();
      _focusNode.requestFocus();
      return;
    }

    _focusNode.unfocus();
    Future.microtask(() {
      if (!mounted) return;
      setState(() {
        _isEmojiPickerVisible = true;
      });
    });
    SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
  }

  bool _looksLikeImage(String fileName, String? mimeType) {
    final normalized = fileName.toLowerCase();
    final mediaType = (mimeType ?? '').toLowerCase();
    return mediaType.startsWith('image/') ||
        normalized.endsWith('.png') ||
        normalized.endsWith('.jpg') ||
        normalized.endsWith('.jpeg') ||
        normalized.endsWith('.gif') ||
        normalized.endsWith('.webp');
  }

  Future<void> _pickAttachment(_AttachmentPickerSource source) async {
    if (source == _AttachmentPickerSource.file) {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        withData: true,
      );
      final selected = result?.files.single;
      if (selected == null) {
        return;
      }

      final fileName = selected.name.trim();
      if (fileName.isEmpty) {
        return;
      }

      final fileBytes = selected.bytes ?? const <int>[];
      final effectiveBytes = fileBytes.isNotEmpty
          ? Uint8List.fromList(fileBytes)
          : (selected.path == null
                ? Uint8List(0)
                : Uint8List.fromList(await File(selected.path!).readAsBytes()));

      final detectedMimeType =
          lookupMimeType(selected.path ?? '') ?? 'application/octet-stream';

      if (!mounted) return;
      setState(() {
        _pendingAttachment = _PendingAttachment(
          fileName: fileName,
          bytes: effectiveBytes,
          mimeType: detectedMimeType,
          filePath: selected.path,
          isImage: _looksLikeImage(fileName, detectedMimeType),
        );
      });
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source == _AttachmentPickerSource.gallery
          ? ImageSource.gallery
          : ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );

    if (pickedFile == null) {
      return;
    }

    final data = await pickedFile.readAsBytes();
    if (!mounted) return;
    setState(() {
      _pendingAttachment = _PendingAttachment(
        fileName: pickedFile.name,
        bytes: data,
        mimeType: lookupMimeType(pickedFile.path) ?? 'image/jpeg',
        filePath: pickedFile.path,
        isImage: true,
      );
    });
  }

  Future<void> _openAttachmentPicker() async {
    final source = await showModalBottomSheet<_AttachmentPickerSource>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.photo_library_rounded,
                    color: colorScheme.primary,
                  ),
                  title: const Text('Zdjęcia z galerii'),
                  onTap: () => Navigator.of(
                    context,
                  ).pop(_AttachmentPickerSource.gallery),
                ),
                ListTile(
                  leading: Icon(
                    Icons.attach_file_rounded,
                    color: colorScheme.primary,
                  ),
                  title: const Text('Plik'),
                  onTap: () =>
                      Navigator.of(context).pop(_AttachmentPickerSource.file),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null) {
      return;
    }

    await _pickAttachment(source);
  }

  Future<void> _openCamera() async {
    if (!AttachmentCameraSupport.isCameraSupportedOnCurrentPlatform()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AttachmentCameraSupport.cameraTooltip())),
      );
      return;
    }

    await _pickAttachment(_AttachmentPickerSource.camera);
  }

  Future<String?> _uploadPendingAttachment() async {
    final pending = _pendingAttachment;
    if (pending == null) {
      return null;
    }

    if (pending.bytes.isEmpty) {
      if (!mounted) return null;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Wybrany plik jest pusty.')));
      return null;
    }

    if (pending.bytes.length > 25 * 1024 * 1024) {
      if (!mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plik jest za duży. Maksymalnie 25 MB.')),
      );
      return null;
    }

    final apiClient = ref.read(chatsApiClientProvider);
    final crypto = ref.read(symmetricCryptoProvider);
    final storage = ref.read(secureStorageProvider);
    final localAttachmentStore = ref.read(localAttachmentStoreProvider);
    final repository = ref.read(chatsRepositoryProvider);

    try {
      final response = await apiClient.prepareAttachmentUpload(
        conversationId: widget.conversationId,
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
      await storage.write(
        key: keyRef,
        value: keyValue,
      );
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
            'Attachment upload failed for conversation ${widget.conversationId}',
            error: error,
            stackTrace: stackTrace,
            module: 'MessageInputField',
          );
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'message_input_field',
          context: ErrorDescription('Attachment upload failed'),
        ),
      );

      if (!mounted) return null;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nie udało się wysłać załącznika. Spróbuj ponownie.'),
        ),
      );
      return null;
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    final hasAttachment = _pendingAttachment != null;
    if (text.isEmpty && !hasAttachment) {
      return;
    }

    String? attachmentId;
    if (hasAttachment) {
      attachmentId = await _uploadPendingAttachment();
      if (attachmentId == null) {
        return;
      }
    }

    await ref
        .read(activeChatProvider(widget.conversationId).notifier)
        .sendMessage(text.isEmpty ? '' : text, attachmentId: attachmentId);

    if (!mounted) return;
    _controller.clear();
    _lastValidSelection = const TextSelection.collapsed(offset: 0);
    _updateTextState('');
    _closeEmojiPicker();
    _focusNode.unfocus();
    setState(() {
      _pendingAttachment = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textState = ref.watch(messageInputProvider(widget.conversationId));
    final canSend = textState.trim().isNotEmpty || _pendingAttachment != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: _toggleEmojiPicker,
                  icon: Icon(
                    _isEmojiPickerVisible
                        ? Icons.keyboard_rounded
                        : Icons.emoji_emotions_outlined,
                  ),
                  tooltip: _isEmojiPickerVisible
                      ? 'Wpisz tekst'
                      : 'Wybierz emoji',
                  color: colorScheme.onSurface,
                ),
                IconButton(
                  onPressed: _openAttachmentPicker,
                  icon: const Icon(Icons.attach_file_rounded),
                  tooltip: 'Dodaj załącznik',
                  color: colorScheme.onSurface,
                ),
                IconButton(
                  onPressed: AttachmentCameraSupport.isCameraButtonEnabled()
                      ? _openCamera
                      : null,
                  icon: const Icon(Icons.photo_camera_rounded),
                  tooltip: AttachmentCameraSupport.cameraTooltip(),
                  color: colorScheme.onSurface,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onTap: () {
                      if (_isEmojiPickerVisible) {
                        _closeEmojiPicker();
                      }
                    },
                    onChanged: _updateTextState,
                    minLines: 1,
                    maxLines: 4,
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Napisz wiadomość...',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.25,
                          ),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.25,
                          ),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(
                          color: colorScheme.primary,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: canSend ? _sendMessage : null,
                  icon: const Icon(Icons.send_rounded),
                  style: IconButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    disabledBackgroundColor:
                        colorScheme.surfaceContainerHighest,
                    disabledForegroundColor: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (_pendingAttachment != null)
              Align(
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
                        if (_pendingAttachment!.isImage)
                          SizedBox(
                            width: 72,
                            height: 72,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                              child: Image.memory(
                                _pendingAttachment!.bytes,
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
                                  _pendingAttachment!.fileName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _pendingAttachment!.isImage
                                      ? 'Zdjęcie'
                                      : _pendingAttachment!.mimeType,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              setState(() => _pendingAttachment = null),
                          icon: const Icon(Icons.close_rounded),
                          tooltip: 'Usuń załącznik',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (_isEmojiPickerVisible)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  height: 280,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      _insertEmoji(emoji.emoji);
                    },
                    config: Config(
                      height: 280,
                      checkPlatformCompatibility: true,
                      emojiViewConfig: EmojiViewConfig(
                        backgroundColor: colorScheme.surface,
                        emojiSizeMax: 28,
                        gridPadding: EdgeInsets.zero,
                      ),
                      categoryViewConfig: CategoryViewConfig(
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        iconColorSelected: colorScheme.primary,
                        iconColor: colorScheme.onSurfaceVariant,
                      ),
                      bottomActionBarConfig: BottomActionBarConfig(
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        buttonColor: colorScheme.primary,
                        showBackspaceButton: true,
                      ),
                      searchViewConfig: SearchViewConfig(
                        backgroundColor: colorScheme.surface,
                        buttonIconColor: colorScheme.onSurfaceVariant,
                        hintText: 'Szukaj emoji',
                        inputTextStyle: theme.textTheme.bodyMedium,
                      ),
                      skinToneConfig: const SkinToneConfig(enabled: true),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PendingAttachment {
  const _PendingAttachment({
    required this.fileName,
    required this.bytes,
    required this.mimeType,
    this.filePath,
    required this.isImage,
  });

  final String fileName;
  final Uint8List bytes;
  final String mimeType;
  final String? filePath;
  final bool isImage;

  String get fileHash => _sha256Hash(bytes);

  static String _sha256Hash(List<int> bytes) {
    return sha256.convert(bytes).toString();
  }
}
