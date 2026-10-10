import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/tables/outbox_events.dart';

part 'outbox_dao.g.dart';

@DriftAccessor(tables: [OutboxEvents])
class OutboxDao extends DatabaseAccessor<AppDatabase> with _$OutboxDaoMixin {
  OutboxDao(super.db);

  Future<void> enqueueEvent(OutboxEventsCompanion event) async {
    try {
      final payloadJson = event.payload.value;
      final payloadMap = _readPayloadMap(payloadJson);
      final targetId = payloadMap?['id']?.toString() ??
          payloadMap?['entity_id']?.toString();
      final action = payloadMap?['action']?.toString() ??
          payloadMap?['event_type']?.toString();

      if (targetId == null) {
        await into(outboxEvents).insert(event);
        return;
      }

      final pending = await (select(outboxEvents)
            ..where((t) => t.status.equals('pending'))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

      final related = pending.where((row) {
        final next = _readPayloadMap(row.payload);
        return next?['id']?.toString() == targetId ||
            next?['entity_id']?.toString() == targetId;
      }).toList();

      if (action == 'mark_read' &&
          related.any((row) => row.eventType == 'notification.mark_read')) {
        return;
      }

      if ((action == 'ADD_CONTACT' || action == 'RESPOND_CONTACT') &&
          related.any((row) => row.eventType == action)) {
        return;
      }

      if (action == 'restore' &&
          related.any((row) => row.eventType == 'notification.move_to_trash')) {
        final idsToDelete = related
            .where((row) => row.eventType == 'notification.move_to_trash')
            .map((row) => row.id)
            .toList();
        if (idsToDelete.isNotEmpty) {
          await (delete(outboxEvents)
                ..where((t) => t.id.isIn(idsToDelete)))
              .go();
          return;
        }
      }

      if (action == 'delete' &&
          related.any((row) => row.eventType == 'notification.move_to_trash')) {
        final idsToDelete = related
            .where((row) => row.eventType == 'notification.move_to_trash')
            .map((row) => row.id)
            .toList();
        if (idsToDelete.isNotEmpty) {
          await (delete(outboxEvents)
                ..where((t) => t.id.isIn(idsToDelete)))
              .go();
        }
        await into(outboxEvents).insert(event);
        return;
      }

      await into(outboxEvents).insert(event);
    } catch (_) {
      await into(outboxEvents).insert(event);
    }
  }

  Map<String, dynamic>? _readPayloadMap(String rawJson) {
    if (rawJson.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
      return null;
    } catch (_) {
      return null;
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
