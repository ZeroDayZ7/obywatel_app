import 'dart:convert';

import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/features/notifications/data/notification_api.dart';

/// NotificationSyncHandler is a simple stateless handler used by the SyncEngine
/// to process outbox events related to notifications.
class NotificationSyncHandler {
  Future<bool> handle(OutboxEventEntity event, NotificationApi api) async {
    try {
      final payload = jsonDecode(event.payload);
      final id = payload['id']?.toString();

      switch (event.eventType) {
        case 'notification.mark_read':
          if (id != null) return await _call(api.markAsRead, id);
          break;
        case 'notification.mark_all_read':
          return await _callVoid(api.markAllAsRead);
        case 'notification.move_to_trash':
          if (id != null) return await _call(api.moveToTrash, id);
          break;
        case 'notification.restore':
          if (id != null) return await _call(api.restoreFromTrash, id);
          break;
        case 'notification.delete':
          if (id != null) return await _call(api.deletePermanently, id);
          break;
        case 'notification.clear_trash':
          return await _callVoid(api.clearTrash);
      }
    } catch (_) {
      return false;
    }
    return false;
  }

  Future<bool> _call(Future<void> Function(String) fn, String id) async {
    try {
      await fn(id);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _callVoid(Future<void> Function() fn) async {
    try {
      await fn();
      return true;
    } catch (_) {
      return false;
    }
  }
}
