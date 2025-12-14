import 'package:obywatel_plus/features/notifications/data/local/hive/app_notification_hive.dart';
import 'package:obywatel_plus/features/notifications/domain/entities/notification.dart';
import 'package:obywatel_plus/features/notifications/domain/entities/notification_type.dart';

extension HiveToEntity on AppNotification {
  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      readAt: readAt,
      type: NotificationType.values.byName(type),
      route: route,
    );
  }
}

extension EntityToHive on NotificationEntity {
  AppNotification toHiveModel() {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      readAt: readAt,
      type: type.name,
      route: route,
    );
  }
}
