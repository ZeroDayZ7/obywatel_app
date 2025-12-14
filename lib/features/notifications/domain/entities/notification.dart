import 'package:obywatel_plus/features/notifications/domain/entities/notification_type.dart';

class NotificationEntity {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final DateTime? readAt;
  final NotificationType type;
  final String? route;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.readAt,
    required this.type,
    this.route,
  });

  bool get isRead => readAt != null;
}
