import 'package:drift/drift.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/tables/notifications.dart';
import 'package:obywatel_plus/features/notifications/domain/notification_model.dart';

part 'notifications_dao.g.dart';
// ... importy bez zmian

@DriftAccessor(tables: [Notifications])
class NotificationsDao extends DatabaseAccessor<AppDatabase>
    with _$NotificationsDaoMixin {
  NotificationsDao(super.db);

  Stream<List<NotificationModel>> watchAllNotifications() {
    return (select(notifications)
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .watch()
        .map((rows) => rows.map((row) => _mapToModel(row)).toList());
  }

  // NOWE: Stream specjalnie dla widoku Kosza
  Stream<List<NotificationModel>> watchTrashNotifications() {
    return (select(notifications)
          ..where((t) => t.deletedAt.isNotNull())
          ..orderBy([(t) => OrderingTerm.desc(t.deletedAt)]))
        .watch()
        .map((rows) => rows.map((row) => _mapToModel(row)).toList());
  }

  // NOWE: Oznaczanie wszystkich jako przeczytane
  Future<void> markAllAsRead() async {
    await (update(notifications)..where((t) => t.isRead.equals(false))).write(
      const NotificationsCompanion(isRead: Value(true)),
    );
  }

  // NOWE: Przenoszenie do kosza / Przywracanie
  Future<void> updateDeletedAt(String id, DateTime? date) async {
    await (update(notifications)..where((t) => t.id.equals(id))).write(
      NotificationsCompanion(deletedAt: Value(date)),
    );
  }

  // Metoda do całkowitego opróżnienia kosza
  Future<void> deleteAllTrash() async {
    await (delete(notifications)..where((t) => t.deletedAt.isNotNull())).go();
  }

  // NOWE: Usuwanie starych rekordów (np. starszych niż 7 dni)
  Future<void> deleteOlderThan(DateTime date) async {
    await (delete(
      notifications,
    )..where((t) => t.deletedAt.isSmallerThanValue(date))).go();
  }

  Future<void> upsertNotifications(List<NotificationModel> items) async {
    await batch((batch) {
      batch.insertAll(
        notifications,
        items.map(
          (item) => NotificationsCompanion.insert(
            id: item.id,
            title: item.title,
            content: item.content,
            createdAt: item.createdAt,
            priority: item.priority,
            category: item.category,
            isRead: Value(item.isRead),
          ),
        ),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  // POPRAWIONY MAPPER: Zmienna typu DbNotification zamiast Notification
  NotificationModel _mapToModel(DbNotification row) {
    return NotificationModel(
      id: row.id,
      title: row.title,
      content: row.content,
      createdAt: row.createdAt,
      priority: row.priority,
      category: row.category,
      isRead: row.isRead,
    );
  }

  Future<void> markAsRead(String id) async {
    await (update(notifications)..where((t) => t.id.equals(id))).write(
      const NotificationsCompanion(isRead: Value(true)),
    );
  }

  // Opcjonalnie dodaj od razu usuwanie:
  Future<void> deleteNotification(String id) async {
    await (delete(notifications)..where((t) => t.id.equals(id))).go();
  }
}
