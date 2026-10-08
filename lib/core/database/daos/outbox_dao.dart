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
          final Map<String, dynamic> data = jsonDecode(payloadJson) as Map<String, dynamic>;
          targetId = data['id']?.toString() ?? data['entity_id']?.toString();
          action = data['action']?.toString() ?? data['event_type']?.toString();
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
          final Map<String, dynamic> d = jsonDecode(e.payload) as Map<String, dynamic>;
          return d['id']?.toString() == targetId;
        } catch (_) {
          return false;
        }
      }).toList();

      // 1) coalesce multiple mark_read -> keep first pending mark_read only
      if (action == 'mark_read' && related.any((e) => e.eventType == 'notification.mark_read')) {
        return;
      }

      if ((action == 'ADD_CONTACT' || action == 'RESPOND_CONTACT') &&
          related.any((e) => e.eventType == action)) {
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

  Future<List<OutboxEventEntity>> getRetryEligibleEvents({DateTime? referenceTime}) async {
    final now = referenceTime ?? DateTime.now();
    final rows = await (select(outboxEvents)
          ..where((t) => t.status.equals('pending'))
          ..where((t) => t.nextAttemptAt.isNull() | t.nextAttemptAt.isSmallerOrEqualValue(now))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
    return rows;
  }

  Future<OutboxEventEntity?> getRowById(String id) {
    return (select(outboxEvents)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> deleteEventsByIds(List<String> ids) async {
    if (ids.isEmpty) return;
    await (delete(outboxEvents)..where((t) => t.id.isIn(ids))).go();
  }

  Future<void> markAsSending(List<String> ids) async {
    await (update(outboxEvents)..where((t) => t.id.isIn(ids))).write(
      const OutboxEventsCompanion(status: Value('sending')),
    );
  }

  Future<void> markAsPending(String id, {DateTime? nextAttemptAt}) async {
    await (update(outboxEvents)..where((t) => t.id.equals(id))).write(
      OutboxEventsCompanion(
        status: const Value('pending'),
        nextAttemptAt: Value(nextAttemptAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> incrementRetryCount(String id) async {
    final event = await (select(
      outboxEvents,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (event != null) {
      final nextRetry = event.retryCount + 1;
      final nextAttempt = event.attemptCount + 1;
      await (update(outboxEvents)..where((t) => t.id.equals(id))).write(
        OutboxEventsCompanion(
          retryCount: Value(nextRetry),
          attemptCount: Value(nextAttempt),
          status: const Value('pending'),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  Future<void> scheduleRetry(
    String id, {
    required int retryCount,
    DateTime? referenceTime,
  }) async {
    final now = referenceTime ?? DateTime.now();
    final delayMs = _backoffDelayForAttempt(retryCount);
    final nextAttemptAt = now.add(Duration(milliseconds: delayMs));

    await (update(outboxEvents)..where((t) => t.id.equals(id))).write(
      OutboxEventsCompanion(
        retryCount: Value(retryCount),
        status: const Value('pending'),
        nextAttemptAt: Value(nextAttemptAt),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> deleteEvents(List<String> ids) async {
    await (delete(outboxEvents)..where((t) => t.id.isIn(ids))).go();
  }

  int _backoffDelayForAttempt(int retryCount) {
    final base = 1000;
    final cap = 30000;
    final exponential = base * (1 << (retryCount.clamp(1, 6) - 1));
    return exponential > cap ? cap : exponential;
  }
}
