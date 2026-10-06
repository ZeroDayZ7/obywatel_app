import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/tables/outbox_events.dart';

part 'outbox_dao.g.dart';

@DriftAccessor(tables: [OutboxEvents])
class OutboxDao extends DatabaseAccessor<AppDatabase> with _$OutboxDaoMixin {
  OutboxDao(super.db);

  Future<void> enqueueEvent(OutboxEventsCompanion event) async {
    // Compaction rules: we keep OutboxEvents table schema unchanged and
    // rely on JSON `payload` to identify the target notification id and action.
    // If there are existing pending events for the same notification that are
    // redundant or cancel each other out, we update/delete them instead of
    // inserting a new row.
    try {
      final payloadJson = event.payload.value;
      String? targetId;
      String? action;

      // Try to extract id and action from JSON payload
      try {
        if (payloadJson.isNotEmpty) {
          final Map<String, dynamic> data = jsonDecode(payloadJson);
          targetId = data['id']?.toString();
          action = data['action']?.toString();
        }
      } catch (_) {
        // ignore parsing errors; fall back to inserting event
      }

      if (targetId == null) {
        await into(outboxEvents).insert(event);
        return;
      }

      // Fetch pending events and filter those that reference same id
      final pending = await (select(outboxEvents)
            ..where((t) => t.status.equals('pending'))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

      final related = pending.where((e) {
        try {
          final Map<String, dynamic> d = jsonDecode(e.payload);
          return d['id']?.toString() == targetId;
        } catch (_) {
          return false;
        }
      }).toList();

      // 1) coalesce multiple mark_read -> keep first pending mark_read only
      if (action == 'mark_read' && related.any((e) => e.eventType == 'notification.mark_read')) {
        return;
      }

      // 2) move_to_trash then restore -> cancel both
      if (action == 'restore' && related.any((e) => e.eventType == 'notification.move_to_trash')) {
        final idsToDelete = related
            .where((e) => e.eventType == 'notification.move_to_trash')
            .map((e) => e.id)
            .toList();
        if (idsToDelete.isNotEmpty) {
          await (delete(outboxEvents)..where((t) => t.id.isIn(idsToDelete))).go();
          return;
        }
      }

      // 3) delete after move_to_trash -> remove move_to_trash, insert delete
      if (action == 'delete' && related.any((e) => e.eventType == 'notification.move_to_trash')) {
        final idsToDelete = related
            .where((e) => e.eventType == 'notification.move_to_trash')
            .map((e) => e.id)
            .toList();
        if (idsToDelete.isNotEmpty) {
          await (delete(outboxEvents)..where((t) => t.id.isIn(idsToDelete))).go();
        }
        await into(outboxEvents).insert(event);
        return;
      }

      // Default: insert event
      await into(outboxEvents).insert(event);
    } catch (e) {
      // Fallback: ensure event is persisted if compaction logic fails
      await into(outboxEvents).insert(event);
    }
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
