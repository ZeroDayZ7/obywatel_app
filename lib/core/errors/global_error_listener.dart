// lib/core/errors/global_error_listener.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/notifications/feedback_service.dart';
import 'package:obywatel_plus/core/notifications/feedback_type.dart';

import 'global_error_provider.dart';

class GlobalErrorListener extends ConsumerWidget {
  final Widget child;
  const GlobalErrorListener({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AppNotification?>(globalNotificationProvider, (previous, next) {
      if (next != null) {
        // 1. Najpierw wywołaj efekt fizyczny (wibracja/dźwięk)
        _triggerFeedback(ref, next.type);

        // 2. Potem pokaż UI (SnackBar)
        _showAdaptiveSnackBar(context, next);
      }
    });
    return child;
  }

  // PRYWATNA METODA DO MAPOWANIA I URUCHAMIANIA FEEDBACKU
  void _triggerFeedback(WidgetRef ref, NotificationType type) {
    final feedbackService = ref.read(feedbackServiceProvider);

    // Mapujemy typ powiadomienia na typ fizycznego feedbacku
    final feedbackType = switch (type) {
      NotificationType.error => FeedbackType.error,
      NotificationType.warning => FeedbackType.warning,
      NotificationType.success => FeedbackType.success,
      NotificationType.info => FeedbackType.info,
    };

    feedbackService.trigger(feedbackType);
  }

  void _showAdaptiveSnackBar(
    BuildContext context,
    AppNotification notification,
  ) {
    final size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 600;

    // Definiujemy style dla typów
    final Map<NotificationType, _ToastStyle> styles = {
      NotificationType.error: _ToastStyle(
        color: Colors.red.shade800,
        icon: Icons.error_outline,
      ),
      NotificationType.warning: _ToastStyle(
        color: Colors.orange.shade700, // Żółty/Pomarańczowy dla ostrzeżeń
        icon: Icons.warning_amber_rounded,
      ),
      NotificationType.success: _ToastStyle(
        color: Colors.green.shade800,
        icon: Icons.check_circle_outline,
      ),
      NotificationType.info: _ToastStyle(
        color: Colors.blue.shade800,
        icon: Icons.info_outline,
      ),
    };

    final style = styles[notification.type] ?? styles[NotificationType.error]!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(style.icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                notification.messageKey.tr(namedArgs: notification.namedArgs),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: style.color,
        behavior: SnackBarBehavior.floating,
        width: isDesktop ? 400 : null,
        margin: isDesktop ? null : const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}

class _ToastStyle {
  final Color color;
  final IconData icon;
  _ToastStyle({required this.color, required this.icon});
}
