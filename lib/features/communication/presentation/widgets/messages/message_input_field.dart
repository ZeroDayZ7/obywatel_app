import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:obywatel_plus/core/notifications/feedback_service.dart';
import 'package:obywatel_plus/core/notifications/feedback_type.dart';
import 'package:obywatel_plus/core/notifications/notification_settings.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/message_input_provider.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messages/message_attachment_preview.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messages/message_input_toolbar.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messages/message_text_field.dart';

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
  const MessageInputField({super.key, required this.conversationId});

  final String conversationId;

  @override
  ConsumerState<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends ConsumerState<MessageInputField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isEmojiPickerVisible = false;
  TextSelection? _lastValidSelection;
  String? _lastDisplayedError;

  ProviderSubscription<MessageInputState>? _subscription;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _controller.addListener(_syncSelection);
    _syncControllerFromProvider();

    _subscription = ref.listenManual<MessageInputState>(
      messageInputProvider(widget.conversationId),
      (previous, next) {
        if (!mounted) return;

        if (_controller.text != next.text) {
          _controller.value = TextEditingValue(
            text: next.text,
            selection: TextSelection.collapsed(offset: next.text.length),
            composing: TextRange.empty,
          );
        }

        final currentError = next.errorMessage;
        if (currentError != null &&
            currentError != _lastDisplayedError &&
            currentError.trim().isNotEmpty) {
          _lastDisplayedError = currentError;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(currentError)));
          });
        }

        if (currentError == null) {
          _lastDisplayedError = null;
        }
      },
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _subscription?.close();
    _controller.removeListener(_syncSelection);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _syncControllerFromProvider() {
    final state = ref.read(messageInputProvider(widget.conversationId));
    if (_controller.text != state.text) {
      _controller.value = TextEditingValue(
        text: state.text,
        selection: TextSelection.collapsed(offset: state.text.length),
        composing: TextRange.empty,
      );
    }
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
      await ref
          .read(messageInputProvider(widget.conversationId).notifier)
          .setAttachmentSelection(
            fileName: fileName,
            bytes: effectiveBytes,
            mimeType: detectedMimeType,
            filePath: selected.path,
          );
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
    await ref
        .read(messageInputProvider(widget.conversationId).notifier)
        .setAttachmentSelection(
          fileName: pickedFile.name.trim().isNotEmpty
              ? pickedFile.name
              : 'photo.jpg',
          bytes: data,
          mimeType: lookupMimeType(pickedFile.path) ?? 'image/jpeg',
          filePath: pickedFile.path,
          isImage: true,
        );
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

  Future<void> _sendMessage() async {
    final notifier = ref.read(
      messageInputProvider(widget.conversationId).notifier,
    );
    final wasSent = await notifier.sendCurrentMessage();

    if (!mounted) {
      return;
    }

    if (wasSent) {
      ref.read(feedbackServiceProvider).trigger(
        FeedbackType.success,
        moduleId: NotificationModuleId.communication,
      );
    } else {
      ref.read(feedbackServiceProvider).trigger(
        FeedbackType.error,
        moduleId: NotificationModuleId.communication,
      );
    }

    if (wasSent) {
      _closeEmojiPicker();
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final inputState = ref.watch(messageInputProvider(widget.conversationId));
    final attachment = inputState.attachment;
    final canSend = inputState.canSend && !inputState.isSending;

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
                MessageInputToolbar(
                  isEmojiVisible: _isEmojiPickerVisible,
                  onToggleEmoji: _toggleEmojiPicker,
                  onOpenAttachmentPicker: _openAttachmentPicker,
                  onOpenCamera: AttachmentCameraSupport.isCameraButtonEnabled()
                      ? _openCamera
                      : null,
                ),
                MessageTextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onTap: () {
                    if (_isEmojiPickerVisible) {
                      _closeEmojiPicker();
                    }
                  },
                  onChanged: _updateTextState,
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: canSend ? _sendMessage : null,
                  icon: inputState.isSending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send_rounded),
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
            if (attachment != null)
              MessageAttachmentPreview(
                attachment: attachment,
                isSending: inputState.isSending,
                onRemove: inputState.isSending
                    ? () {}
                    : () => ref
                          .read(
                            messageInputProvider(
                              widget.conversationId,
                            ).notifier,
                          )
                          .clearAttachment(),
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
