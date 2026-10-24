import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/communication/domain/chats/conversation.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/conversations/conversation_avatar.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/conversations/conversation_preview.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/conversations/conversation_time_formatter.dart';

class ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final VoidCallback? onTap;

  // Tymczasowy placeholder: można ręcznie przełączać status online/offline
  // w miejscu użycia widżetu, dopóki nie podłączymy realnego źródła danych.
  final bool isOnline;

  const ConversationTile({
    super.key,
    required this.conversation,
    this.onTap,
    this.isOnline = false,
  });

  String _displayName() {
    final normalizedTitle = (conversation.title ?? '').trim();
    if (normalizedTitle.isNotEmpty) {
      return normalizedTitle;
    }

    final id = conversation.id.trim();
    if (id.length <= 4) {
      return 'Konwersacja #$id';
    }
    return 'Konwersacja #${id.substring(0, 4)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final timeText = ConversationTimeFormatter.formatTime(
      conversation.updatedAt,
    );
    final unreadCount = conversation.unreadCount;
    final hasUnread = unreadCount > 0;

    final statusColor = isOnline
        ? const Color(0xFF00E676)
        : colorScheme.outline.withValues(alpha: 0.6);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: hasUnread
            ? colorScheme.primaryContainer.withValues(alpha: 0.25)
            : colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: hasUnread
              ? colorScheme.primary.withValues(alpha: 0.6)
              : colorScheme.outline.withValues(alpha: 0.2),
          width: hasUnread ? 1.5 : 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Awatar z wbudowaną kropką statusu
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ConversationAvatar(conversation: conversation),
                    Positioned(
                      right: -1,
                      bottom: -1,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.surfaceContainerHigh,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _displayName(),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: hasUnread ? FontWeight.w800 : FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            timeText,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: hasUnread
                                  ? colorScheme.primary
                                  : colorScheme.onSurfaceVariant,
                              fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      DefaultTextStyle(
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: hasUnread
                              ? colorScheme.onSurface
                              : colorScheme.onSurfaceVariant,
                          fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                        ),
                        child: ConversationPreview(conversation: conversation),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (hasUnread)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Center(
                          child: Text(
                            unreadCount > 99 ? '99+' : unreadCount.toString(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}