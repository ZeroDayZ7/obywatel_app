import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/features/notifications/data/notification_api.dart';
import 'package:obywatel_plus/features/notifications/data/notifications_repository.dart';
import 'package:obywatel_plus/features/notifications/domain/notification_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifications_controller.g.dart';

@riverpod
class NotificationsController extends _$NotificationsController {
  @override
  Stream<List<NotificationModel>> build() {
    final stream = ref.watch(notificationsDaoProvider).watchAllNotifications();
    // Automatycznie czyść stary kosz przy inicjalizacji kontrolera (opcjonalnie)
    // vacuumOldNotifications();
    Future.microtask(() => syncWithBackend());

    return stream;
  }

  Future<void> markAsRead(String id) async {
    await markAsRead(
      ref.read(appDatabaseProvider),
      ref.read(notificationsDaoProvider),
      ref.read(outboxDaoProvider),
      id,
    );
  }

  Future<void> markAllAsRead() async {
    final logger = ref.read(appLoggerProvider);
    await markAllAsRead(
      ref.read(appDatabaseProvider),
      ref.read(notificationsDaoProvider),
      ref.read(outboxDaoProvider),
    );
    logger.i('Queued mark_all_read in outbox');
  }

  Future<void> moveToTrash(String id) async {
    await moveToTrash(
      ref.read(appDatabaseProvider),
      ref.read(notificationsDaoProvider),
      ref.read(outboxDaoProvider),
      id,
    );
  }

  Future<void> clearAllTrash() async {
    await clearTrash(
      ref.read(appDatabaseProvider),
      ref.read(notificationsDaoProvider),
      ref.read(outboxDaoProvider),
    );
    ref.read(appLoggerProvider).i('Queued clear_trash in outbox');
  }

  Future<void> restoreFromTrash(String id) async {
    await restoreFromTrash(
      ref.read(appDatabaseProvider),
      ref.read(notificationsDaoProvider),
      ref.read(outboxDaoProvider),
      id,
    );
    ref.read(appLoggerProvider).i('Queued restore in outbox');
  }

  Future<void> deletePermanently(String id) async {
    await deletePermanently(
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
    try {
      final api = ref.read(notificationApiProvider);
      final remoteNotifications = await api.fetchNotifications();

      // ZMIANA: Zamiast upsertNotifications, używamy nowej metody sync
      await ref
          .read(notificationsDaoProvider)
          .syncLocalWithRemote(remoteNotifications);

      logger.i(
        '🔄 Synchronizacja zakończona: ${remoteNotifications.length} powiadomień',
      );
    } catch (e, st) {
      logger.e('❌ Błąd synchronizacji powiadomień', error: e, stackTrace: st);
    }
  }
}

@riverpod
Stream<List<NotificationModel>> trashNotifications(Ref ref) {
  return ref.watch(notificationsDaoProvider).watchTrashNotifications();
}
