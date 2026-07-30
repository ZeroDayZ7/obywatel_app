import 'package:drift/drift.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/tables/outbox_events.dart';

part 'outbox_dao.g.dart';

@DriftAccessor(tables: [OutboxEvents])
class OutboxDao extends DatabaseAccessor<AppDatabase> with _$OutboxDaoMixin {
  OutboxDao(super.db);

  Future<void> enqueueEvent(OutboxEventsCompanion event) async {
    await into(outboxEvents).insert(event);
  }

  Future<List<OutboxEventEntity>> getPendingEvents() {
    return (select(outboxEvents)
          ..where((t) => t.status.equals('pending'))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<void> markAsSending(List<String> ids) async {
    await (update(outboxEvents)..where((t) => t.id.isIn(ids))).write(
      const OutboxEventsCompanion(status: Value('sending')),
    );
  }

  Future<void> incrementRetryCount(String id) async {
    final event = await (select(
      outboxEvents,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (event != null) {
      await (update(outboxEvents)..where((t) => t.id.equals(id))).write(
        OutboxEventsCompanion(
          retryCount: Value(event.retryCount + 1),
          status: const Value('pending'),
        ),
      );
    }
  }

  Future<void> deleteEvents(List<String> ids) async {
    await (delete(outboxEvents)..where((t) => t.id.isIn(ids))).go();
  }
}
