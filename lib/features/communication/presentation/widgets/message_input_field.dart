import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/active_chat_provider.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/message_input_provider.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateTextState(String value) {
    ref
        .read(messageInputProvider(widget.conversationId).notifier)
        .updateText(value);
  }

  void _insertEmoji(String emoji) {
    final value = _controller.value;
    final text = value.text;
    final selection = value.selection;

    final int start;
    final int end;

    if (!selection.isValid) {
      start = text.length;
      end = text.length;
    } else {
      start = selection.start.clamp(0, text.length);
      end = selection.end.clamp(start, text.length);
    }

    final newText = text.replaceRange(start, end, emoji);
    final cursorPosition = start + emoji.length;

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursorPosition),
      composing: TextRange.empty,
    );

    _updateTextState(newText);
  }

  void _toggleEmojiPicker() {
    setState(() {
      _isEmojiPickerVisible = !_isEmojiPickerVisible;
    });

    if (_isEmojiPickerVisible) {
      _focusNode.unfocus();
    } else {
      _focusNode.requestFocus();
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    ref
        .read(activeChatProvider(widget.conversationId).notifier)
        .sendMessage(text);
    _controller.clear();
    _updateTextState('');
    setState(() {
      _isEmojiPickerVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textState = ref.watch(messageInputProvider(widget.conversationId));

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
                  onPressed: () {},
                  icon: const Icon(Icons.attach_file_rounded),
                  tooltip: 'Dodaj załącznik',
                  color: colorScheme.onSurface,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: (val) {
                      _updateTextState(val);
                    },
                    minLines: 1,
                    maxLines: 4,
                    style: theme.textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: 'Wpisz komunikat...',
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
                const SizedBox(width: 8.0),
                IconButton.filled(
                  onPressed: textState.trim().isNotEmpty ? _sendMessage : null,
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
            if (_isEmojiPickerVisible)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
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
