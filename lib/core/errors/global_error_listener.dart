import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_error_provider.dart';
import 'package:obywatel_plus/core/notifications/feedback_service.dart';
import 'package:obywatel_plus/core/notifications/feedback_type.dart';

class GlobalErrorListener extends ConsumerWidget {
  final Widget child;
  const GlobalErrorListener({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AppNotification?>(globalNotificationProvider, (prev, next) {
      if (next != null) {
        _handleNotification(context, ref, next);
      }
    });

    return child;
  }

  void _handleNotification(
    BuildContext context,
    WidgetRef ref,
    AppNotification notification,
  ) {
    final feedbackType = _mapToFeedback(notification.type);
    ref.read(feedbackServiceProvider).trigger(feedbackType);

    _showAdaptiveSnackBar(context, notification);
  }

  void _showAdaptiveSnackBar(
    BuildContext context,
    AppNotification notification,
  ) {
    final size = MediaQuery.sizeOf(context);
    final bool isDesktop = size.width > 600;

    final style = _getStyle(notification.type);

    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: style.color,
        behavior: SnackBarBehavior.floating,
        elevation: 8,
        duration: const Duration(seconds: 4),
        dismissDirection: DismissDirection.horizontal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        width: isDesktop ? 400 : null,
        margin: isDesktop
            ? null
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        content: Row(
          children: [
            Icon(style.icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                notification.messageKey.tr(namedArgs: notification.namedArgs),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            if (notification.onActionPressed == null)
              IconButton(
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                onPressed: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              ),
          ],
        ),
        action: notification.onActionPressed != null
            ? SnackBarAction(
                label: notification.actionLabelKey?.tr() ?? '',
                textColor: Colors.white,
                onPressed: notification.onActionPressed!,
              )
            : null,
      ),
    );
  }

  FeedbackType _mapToFeedback(NotificationType type) {
    return switch (type) {
      NotificationType.error => FeedbackType.error,
      NotificationType.warning => FeedbackType.warning,
      NotificationType.success => FeedbackType.success,
      NotificationType.info => FeedbackType.info,
    };
  }

  _ToastStyle _getStyle(NotificationType type) {
    return switch (type) {
      NotificationType.error => _ToastStyle(
        color: Colors.red.shade800,
        icon: Icons.error_outline,
      ),
      NotificationType.warning => _ToastStyle(
        color: Colors.orange.shade700,
        icon: Icons.warning_amber_rounded,
      ),
      NotificationType.success => _ToastStyle(
        color: Colors.green.shade800,
        icon: Icons.check_circle_outline,
      ),
      NotificationType.info => _ToastStyle(
        color: Colors.blue.shade800,
        icon: Icons.info_outline,
      ),
    };
  }
}

class _ToastStyle {
  final Color color;
  final IconData icon;
  _ToastStyle({required this.color, required this.icon});
}
