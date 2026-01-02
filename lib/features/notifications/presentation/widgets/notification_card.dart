import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/utils/date_formatter.dart';

import '../../domain/notification_model.dart';

class NotificationBadge extends StatelessWidget {
  final bool isNew;
  final NotificationCategory category;
  final Color priorityColor;

  const NotificationBadge({
    super.key,
    required this.isNew,
    required this.category,
    required this.priorityColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      alignment: Alignment.topRight,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: isNew
              ? priorityColor.withValues(alpha: 0.15)
              : theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            category.icon,
            color: isNew ? priorityColor : theme.hintColor,
            size: 20,
          ),
        ),
        if (isNew)
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: priorityColor,
              shape: BoxShape.circle,
              border: Border.all(color: theme.colorScheme.surface, width: 2.5),
            ),
          ),
      ],
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationModel item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NotificationCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isNew = !item.isRead;
    final priorityColor = item.priority.color(colors);

    return Material(
      color: isNew
          ? item.priority.containerColor(colors)
          : colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isNew
                  ? priorityColor.withValues(alpha: 0.4)
                  : colors.outlineVariant.withValues(alpha: 0.5),
              width: isNew ? 1.5 : 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NotificationBadge(
                isNew: isNew,
                category: item.category,
                priorityColor: priorityColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _CategoryTag(
                          item: item,
                          priorityColor: priorityColor,
                          isNew: isNew,
                        ),
                        const Spacer(),
                        Text(
                          item.createdAt.formatRelative(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.hintColor,
                            fontWeight: isNew ? FontWeight.w600 : null,
                          ),
                        ),
                        const SizedBox(width: 4),
                        _DeleteButton(onDelete: onDelete, theme: theme),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: isNew ? FontWeight.bold : FontWeight.w600,
                        color: isNew ? colors.onSurface : theme.hintColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.3,
                        color: isNew
                            ? colors.onSurfaceVariant
                            : theme.hintColor.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onDelete, required this.theme});
  final VoidCallback onDelete;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: LocaleKeys.notifications_move_to_trash_action.tr(),
      icon: Icon(
        Icons.delete_outline,
        size: 18,
        color: theme.hintColor.withValues(alpha: 0.5),
      ),
      onPressed: onDelete,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      splashRadius: 20,
    );
  }
}

class _CategoryTag extends StatelessWidget {
  const _CategoryTag({
    required this.item,
    required this.priorityColor,
    required this.isNew,
  });

  final NotificationModel item;
  final Color priorityColor;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isNew
            ? priorityColor.withValues(alpha: 0.1)
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        item.category.label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: isNew ? priorityColor : theme.hintColor,
          fontWeight: FontWeight.bold,
          fontSize: 9,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
