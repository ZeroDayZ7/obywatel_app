import 'package:flutter/material.dart';

class MessageInputToolbar extends StatelessWidget {
  const MessageInputToolbar({
    super.key,
    required this.isEmojiVisible,
    required this.onToggleEmoji,
    required this.onOpenAttachmentPicker,
    required this.onOpenCamera,
  });

  final bool isEmojiVisible;
  final VoidCallback onToggleEmoji;
  final VoidCallback onOpenAttachmentPicker;
  final VoidCallback? onOpenCamera;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        IconButton(
          onPressed: onToggleEmoji,
          icon: Icon(
            isEmojiVisible ? Icons.keyboard_rounded : Icons.emoji_emotions_outlined,
          ),
          tooltip: isEmojiVisible ? 'Wpisz tekst' : 'Wybierz emoji',
          color: colorScheme.onSurface,
        ),
        IconButton(
          onPressed: onOpenAttachmentPicker,
          icon: const Icon(Icons.attach_file_rounded),
          tooltip: 'Dodaj załącznik',
          color: colorScheme.onSurface,
        ),
        IconButton(
          onPressed: onOpenCamera,
          icon: const Icon(Icons.photo_camera_rounded),
          tooltip: 'Zrób zdjęcie',
          color: colorScheme.onSurface,
        ),
      ],
    );
  }
}
