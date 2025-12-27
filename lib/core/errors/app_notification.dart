// lib/core/errors/app_notification.dart
enum NotificationType { success, warning, error, info }

class AppNotification {
  final String messageKey;
  final NotificationType type;
  final Map<String, String>? namedArgs;

  AppNotification({
    required this.messageKey,
    this.type = NotificationType.error,
    this.namedArgs,
  });
}
