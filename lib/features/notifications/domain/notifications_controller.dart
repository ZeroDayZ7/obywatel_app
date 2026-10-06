import 'dart:async';
import 'dart:convert';

import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/sync/sync_coordinator.dart';
import 'package:obywatel_plus/features/notifications/data/notification_api.dart';
import 'package:obywatel_plus/features/notifications/data/notifications_repository.dart' as repo;
import 'package:obywatel_plus/features/notifications/domain/notification_model.dart';
import 'package:obywatel_plus/features/notifications/domain/sync_batch_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_controller.g.dart';

@riverpod
class NotificationsController extends _$NotificationsController {
  bool _syncInProgress = false;

  @override
  Stream<List<NotificationModel>> build() {
    final stream = ref.watch(notificationsDaoProvider).watchAllNotifications();

    ref.listen(syncCoordinatorProvider, (previous, next) {
      if (next == SyncReadiness.ready && previous != SyncReadiness.ready) {
        unawaited(_syncWhenReady());
      }
    });

    if (ref.read(syncCoordinatorProvider) == SyncReadiness.ready) {
      unawaited(_syncWhenReady());
    }

    return stream;
  }

  Future<void> _syncWhenReady() async {
    if (_syncInProgress) return;

    _syncInProgress = true;

    try {
      final readiness = await ref.read(syncCoordinatorProvider.notifier).ensureReady();
      if (readiness != SyncReadiness.ready) {
        return;
      }

      await syncWithBackend();
    } finally {
      _syncInProgress = false;
    }
  }

  Future<void> markAsRead(String id) async {
    await repo.markAsRead(
      ref.read(appDatabaseProvider),
      ref.read(notificationsDaoProvider),
      ref.read(outboxDaoProvider),
      id,
    );
  }

  Future<void> markAllAsRead() async {
    final logger = ref.read(appLoggerProvider);
    await repo.markAllAsRead(
      ref.read(appDatabaseProvider),
      ref.read(notificationsDaoProvider),
      ref.read(outboxDaoProvider),
    );
    logger.i('Queued mark_all_read in outbox');
  }

  Future<void> moveToTrash(String id) async {
    await repo.moveToTrash(
      ref.read(appDatabaseProvider),
      ref.read(notificationsDaoProvider),
      ref.read(outboxDaoProvider),
      id,
    );
  }

  Future<void> clearAllTrash() async {
    await repo.clearTrash(
      ref.read(appDatabaseProvider),
      ref.read(notificationsDaoProvider),
      ref.read(outboxDaoProvider),
    );
    ref.read(appLoggerProvider).i('Queued clear_trash in outbox');
  }

  Future<void> restoreFromTrash(String id) async {
    await repo.restoreFromTrash(
      ref.read(appDatabaseProvider),
      ref.read(notificationsDaoProvider),
      ref.read(outboxDaoProvider),
      id,
    );
    ref.read(appLoggerProvider).i('Queued restore in outbox');
  }

  Future<void> deletePermanently(String id) async {
    await repo.deletePermanently(
      ref.read(appDatabaseProvider),
      ref.read(notificationsDaoProvider),
      ref.read(outboxDaoProvider),
      id,
    );
    ref.read(appLoggerProvider).i('Queued delete in outbox');
  }

  Future<void> vacuumOldNotifications() async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    await ref.read(notificationsDaoProvider).deleteOlderThan(sevenDaysAgo);
  }

  Future<void> syncWithBackend() async {
    final logger = ref.read(appLoggerProvider);
    final api = ref.read(notificationApiProvider);

    // 1) Push: flush outbox
    try {
      final events = await ref.read(appDatabaseProvider).outboxDao.getPendingEvents();
      final notificationEvents = events.where((e) => e.eventType.startsWith('notification.')).toList();

      if (notificationEvents.isNotEmpty) {
        // map to DTOs
        final dtos = notificationEvents.map((e) => SyncEventDto(
              id: e.id,
              eventType: e.eventType,
              payload: (e.payload.isNotEmpty) ? Map<String, dynamic>.from(jsonDecode(e.payload) as Map<String, dynamic>) : {},
              createdAt: e.createdAt.toUtc().toIso8601String(),
            )).toList();

        final resp = await api.syncBatch(dtos);

        // remove processed ids
        if (resp.processedEventIds.isNotEmpty) {
          await ref.read(appDatabaseProvider).outboxDao.deleteEventsByIds(resp.processedEventIds);
        }
      }
    } catch (e, st) {
      logger.e('❌ Błąd wysyłania outboxa', error: e, stackTrace: st);
      // don't proceed to pull if push failed
      return;
    }

    // 2) Pull: fetch latest notifications and apply
    try {
      final remoteNotifications = await api.fetchNotifications();
      await ref.read(notificationsDaoProvider).syncLocalWithRemote(remoteNotifications);
      logger.i('🔄 Synchronizacja zakończona: ${remoteNotifications.length} powiadomień');
    } catch (e, st) {
      logger.e('❌ Błąd pobierania powiadomień', error: e, stackTrace: st);
    }
  }
}

@riverpod
Stream<List<NotificationModel>> trashNotifications(Ref ref) {
  return ref.watch(notificationsDaoProvider).watchTrashNotifications();
}
