// lib/core/errors/app_notification.dart
import 'package:flutter/foundation.dart';

enum NotificationType { success, warning, error, info }

class AppNotification {
  final String messageKey;
  final NotificationType type;
  final Map<String, String>? namedArgs;

  // Nowe pola dla przycisku akcji
  final String?
  actionLabelKey; // Klucz tłumaczenia dla przycisku (np. 'common.undo')
  final VoidCallback? onActionPressed; // Co ma się stać po kliknięciu

  AppNotification({
    required this.messageKey,
    this.type = NotificationType.error,
    this.namedArgs,
    this.actionLabelKey,
    this.onActionPressed,
  });
}
