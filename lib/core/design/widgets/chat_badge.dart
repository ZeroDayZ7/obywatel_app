import 'package:flutter/material.dart';

class ChatBadge extends StatelessWidget {
  final String text;
  final bool isAlert;

  const ChatBadge({super.key, required this.text, this.isAlert = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isAlert
        ? theme.colorScheme.secondary
        : theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.8)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
