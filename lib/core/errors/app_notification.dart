import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

enum NotificationType { success, warning, error, info }

@immutable
class AppNotification {
  final String id;
  final String messageKey;
  final NotificationType type;
  final Map<String, String>? namedArgs;
  final String? actionLabelKey;
  final VoidCallback? onActionPressed;
  final DateTime createdAt;
  final Duration duration;

  AppNotification({
    String? id,
    required this.messageKey,
    this.type = NotificationType.error,
    this.namedArgs,
    this.actionLabelKey,
    this.onActionPressed,
    this.duration = const Duration(seconds: 4),
  }) : id = id ?? const Uuid().v4(),
       createdAt = DateTime.now();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AppNotification && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
