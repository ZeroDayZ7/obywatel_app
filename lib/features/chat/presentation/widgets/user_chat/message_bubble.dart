import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:obywatel_plus/features/chat/domain/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  Widget _buildStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sent:
        return const Icon(Icons.check, size: 12, color: Colors.white70);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 12, color: Colors.white70);
      case MessageStatus.read:
        return const Icon(Icons.done_all, size: 12, color: Colors.blueAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe)
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.purpleAccent,
              child: Text('U'),
            ),
          const SizedBox(width: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              gradient: message.isMe
                  ? const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 32, 75, 67),
                        Color.fromARGB(255, 17, 112, 160),
                      ],
                    )
                  : const LinearGradient(
                      colors: [Color(0xFF6A00FF), Color(0xFFBB00FF)],
                    ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color:
                      (message.isMe
                              ? const Color(0xFF00FFD1)
                              : const Color(0xFF6A00FF))
                          .withValues(alpha: 0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (message.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      message.imageUrl!,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (message.text.isNotEmpty)
                  Text(
                    message.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(message.timestamp),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 4),
                    if (message.isMe) _buildStatusIcon(message.status),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          if (message.isMe)
            const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.cyanAccent,
              child: Text('M'),
            ),
        ],
      ),
    );
  }
}
