import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/widgets/app_avatar.dart';
import 'package:obywatel_plus/core/design/widgets/chat_badge.dart';

class ChatItem extends StatelessWidget {
  final String username;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final VoidCallback? onTap;

  const ChatItem({
    super.key,
    required this.username,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.4),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        leading: AppAvatar(username: username, isOnline: isOnline),
        title: Text(
          username,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        subtitle: Text(
          lastMessage,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        ),

        trailing: SizedBox(
          width: 60,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  time,
                  style: TextStyle(
                    color: theme.colorScheme.primary.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
              ),
              if (unreadCount > 0)
                Align(
                  alignment: Alignment.bottomRight,
                  child: ChatBadge(text: unreadCount.toString()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
