import 'dart:convert';

import 'package:obywatel_plus/core/database/daos/notifications_dao.dart';
import 'package:obywatel_plus/core/database/daos/outbox_dao.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:uuid/uuid.dart';

final _uuid = const Uuid();

Future<void> markAsRead(
  AppDatabase db,
  NotificationsDao notificationsDao,
  OutboxDao outboxDao,
  String id,
) async {
  await db.transaction(() async {
    await notificationsDao.markAsRead(id);

    final payload = jsonEncode({'id': id, 'action': 'mark_read'});
    await outboxDao.enqueueEvent(
      OutboxEventsCompanion.insert(
        id: _uuid.v4(),
        eventType: 'notification.mark_read',
        payload: payload,
      ),
    );
  });
}

Future<void> markAllAsRead(
  AppDatabase db,
  NotificationsDao notificationsDao,
  OutboxDao outboxDao,
) async {
  await db.transaction(() async {
    await notificationsDao.markAllAsRead();

    final payload = jsonEncode({'action': 'mark_all_read'});
    await outboxDao.enqueueEvent(
      OutboxEventsCompanion.insert(
        id: _uuid.v4(),
        eventType: 'notification.mark_all_read',
        payload: payload,
      ),
    );
  });
}

Future<void> moveToTrash(
  AppDatabase db,
  NotificationsDao notificationsDao,
  OutboxDao outboxDao,
  String id,
) async {
  final now = DateTime.now();
  await db.transaction(() async {
    await notificationsDao.updateDeletedAt(id, now);

    final payload = jsonEncode({'id': id, 'action': 'move_to_trash'});
    await outboxDao.enqueueEvent(
      OutboxEventsCompanion.insert(
        id: _uuid.v4(),
        eventType: 'notification.move_to_trash',
        payload: payload,
      ),
    );
  });
}

Future<void> restoreFromTrash(
  AppDatabase db,
  NotificationsDao notificationsDao,
  OutboxDao outboxDao,
  String id,
) async {
  await db.transaction(() async {
    await notificationsDao.updateDeletedAt(id, null);

    final payload = jsonEncode({'id': id, 'action': 'restore'});
    await outboxDao.enqueueEvent(
      OutboxEventsCompanion.insert(
        id: _uuid.v4(),
        eventType: 'notification.restore',
        payload: payload,
      ),
    );
  });
}

Future<void> deletePermanently(
  AppDatabase db,
  NotificationsDao notificationsDao,
  OutboxDao outboxDao,
  String id,
) async {
  await db.transaction(() async {
    await notificationsDao.deleteNotification(id);

    final payload = jsonEncode({'id': id, 'action': 'delete'});
    await outboxDao.enqueueEvent(
      OutboxEventsCompanion.insert(
        id: _uuid.v4(),
        eventType: 'notification.delete',
        payload: payload,
      ),
    );
  });
}

Future<void> clearTrash(
  AppDatabase db,
  NotificationsDao notificationsDao,
  OutboxDao outboxDao,
) async {
  await db.transaction(() async {
    await notificationsDao.deleteAllTrash();

    final payload = jsonEncode({'action': 'clear_trash'});
    await outboxDao.enqueueEvent(
      OutboxEventsCompanion.insert(
        id: _uuid.v4(),
        eventType: 'notification.clear_trash',
        payload: payload,
      ),
    );
  });
}
