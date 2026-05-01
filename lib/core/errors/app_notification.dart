import 'package:flutter/foundation.dart';

enum NotificationType { success, warning, error, info }

class AppNotification {
  final String messageKey;
  final NotificationType type;
  final Map<String, String>? namedArgs;

  final String? actionLabelKey;
  final VoidCallback? onActionPressed;

  AppNotification({
    required this.messageKey,
    this.type = NotificationType.error,
    this.namedArgs,
    this.actionLabelKey,
    this.onActionPressed,
  });
}
