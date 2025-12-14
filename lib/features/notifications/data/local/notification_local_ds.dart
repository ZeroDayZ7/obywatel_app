import 'package:hive/hive.dart';
import 'package:obywatel_plus/features/notifications/data/local/hive/app_notification_hive.dart';
import 'package:obywatel_plus/features/notifications/data/local/notification_mapper.dart';
import 'package:obywatel_plus/features/notifications/domain/entities/notification.dart';


class NotificationLocalDataSource {
  final Box<AppNotification> box;

  NotificationLocalDataSource(this.box);

  Future<void> saveNotifications(List<NotificationEntity> notifications) async {
    for (var n in notifications) {
      await box.put(n.id, n.toHiveModel());
    }
  }

  List<NotificationEntity> getAllNotifications() {
    return box.values.map((n) => n.toEntity()).toList();
  }

  Future<void> markAsRead(String id) async {
    final n = box.get(id);
    if (n != null) {
      n.readAt = DateTime.now();
      await n.save();
    }
  }
}
