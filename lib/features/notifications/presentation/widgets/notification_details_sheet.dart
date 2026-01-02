import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_error_provider.dart';
import 'package:obywatel_plus/features/notifications/domain/notification_model.dart';
import 'package:obywatel_plus/features/notifications/domain/notifications_controller.dart';

import 'notification_card.dart';

class NotificationDetailsSheet {
  static void show(
    BuildContext context,
    WidgetRef ref,
    NotificationModel item,
  ) {
    final theme = Theme.of(context);
    ref.read(notificationsControllerProvider.notifier).markAsRead(item.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHandle(theme),
            _buildHeader(theme, item),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(),
            ),
            Text(
              item.content,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
            const SizedBox(height: 32),
            _buildQuickDeleteButton(context, ref, theme, item.id),
          ],
        ),
      ),
    );
  }

  static Widget _buildHandle(ThemeData theme) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  static Widget _buildHeader(ThemeData theme, NotificationModel item) {
    return Row(
      children: [
        NotificationBadge(
          isNew: false,
          category: item.category,
          priorityColor: item.priority.color(theme.colorScheme),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.category.label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: item.priority.color(theme.colorScheme),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                item.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat.yMMMd().add_Hm().format(item.createdAt),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildQuickDeleteButton(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    String id,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          // 1. Zamknij arkusz szczegółów
          Navigator.pop(context);

          // 2. Przenieś do kosza w bazie danych
          ref.read(notificationsControllerProvider.notifier).moveToTrash(id);

          // 3. Użyj globalnego systemu powiadomień zamiast zwykłego SnackBar
          ref
              .read(globalNotificationProvider.notifier)
              .show(
                AppNotification(
                  messageKey: LocaleKeys.notifications_moved_to_trash,
                  type: NotificationType.info,
                ),
              );
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.colorScheme.error,
          side: BorderSide(
            color: theme.colorScheme.error.withValues(alpha: 0.5),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        icon: const Icon(Icons.delete_outline),
        label: Text(LocaleKeys.notifications_details_delete_button.tr()),
      ),
    );
  }
}
