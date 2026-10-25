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
      final validationError = _validatePayload(payloadMap);
      if (validationError != null) {
        await _markEventAsFailed(
          event,
          'Rejected invalid outbox payload: $validationError',
        );
        return;
      }

      final targetId = payloadMap['id']?.toString() ??
          payloadMap['entityId']?.toString();
      final action = payloadMap['action']?.toString() ??
          payloadMap['eventType']?.toString();

      final isMessageEvent =
          (event.eventType.value == 'SEND_MESSAGE') ||
          (action == 'SEND_MESSAGE');
      final conversationId = payloadMap['conversationId']?.toString();
      final payloadMapValue = payloadMap['payload'];
      final ciphertext = payloadMap['ciphertext']?.toString() ??
          (payloadMapValue is Map
              ? (payloadMapValue)['ciphertext']?.toString()
              : null);

      if (isMessageEvent &&
          (conversationId == null || conversationId.trim().isEmpty ||
              (ciphertext == null || ciphertext.trim().isEmpty))) {
        print(
          '[OUTBOX-DAO-REJECTED] refusing to enqueue invalid SEND_MESSAGE event without conversationId or ciphertext. event_id=${event.id.value} payload_eventType=${action ?? event.eventType.value}',
        );
        await _markEventAsFailed(
          event,
          'Invalid SEND_MESSAGE payload: missing conversationId or ciphertext.',
        );
        return;
      }

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
        return next['id']?.toString() == targetId ||
            next['entityId']?.toString() == targetId;
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
    } on FormatException catch (error) {
      print(
        '[OUTBOX-DAO-REJECTED] invalid payload JSON. event_id=${event.id.value} error=${error.message}',
      );
      await _markEventAsFailed(event, 'Invalid JSON payload: ${error.message}');
    } on ArgumentError catch (error) {
      print(
        '[OUTBOX-DAO-REJECTED] invalid payload structure. event_id=${event.id.value} error=$error',
      );
      await _markEventAsFailed(event, 'Invalid payload structure: $error');
    } on Exception catch (error) {
      print(
        '[OUTBOX-DAO-DB] database error while enqueueing outbox event. event_id=${event.id.value} error=$error',
      );
      rethrow;
    }
  }

  Future<void> _markEventAsFailed(
    OutboxEventsCompanion event,
    String reason,
  ) async {
    final failedEvent = event.copyWith(
      status: const Value('failed'),
      updatedAt: Value(DateTime.now()),
    );

    try {
      await into(outboxEvents).insert(failedEvent);
      print('[OUTBOX-DAO-FAILED] event_id=${event.id.value} reason=$reason');
    } on Exception catch (error) {
      print(
        '[OUTBOX-DAO-FAILED] unable to persist failed outbox record. event_id=${event.id.value} error=$error reason=$reason',
      );
      rethrow;
    }
  }

  String? _validatePayload(Map<String, dynamic>? payloadMap) {
    if (payloadMap == null) {
      return 'payload is not a valid JSON object';
    }

    final candidateId = payloadMap['id'] ?? payloadMap['entityId'];
    if (candidateId != null &&
        candidateId is! String &&
        candidateId is! num &&
        candidateId is! bool) {
      return 'payload id/entityId must be a primitive value';
    }

    final action = payloadMap['action'] ?? payloadMap['eventType'];
    if (action != null && action is! String) {
      return 'payload action/eventType must be string';
    }

    final conversationId = payloadMap['conversationId'];
    if (conversationId != null &&
        conversationId is! String &&
        conversationId is! num) {
      return 'payload conversationId must be string or numeric';
    }

    final payloadValue = payloadMap['payload'];
    if (payloadValue != null && payloadValue is Map) {
      final nestedCiphertext = payloadValue['ciphertext'];
      if (nestedCiphertext != null &&
          nestedCiphertext is! String &&
          nestedCiphertext is! num) {
        return 'payload.payload.ciphertext must be string or numeric';
      }
    }

    final ciphertext = payloadMap['ciphertext'];
    if (ciphertext != null &&
        ciphertext is! String &&
        ciphertext is! num) {
      return 'payload.ciphertext must be string or numeric';
    }

    return null;
  }

  Map<String, dynamic> _readPayloadMap(String rawJson) {
    if (rawJson.trim().isEmpty) {
      throw const FormatException('Payload is empty');
    }

    final decoded = jsonDecode(rawJson);
    if (decoded is! Map) {
      throw const FormatException('Payload must be a JSON object');
    }

    for (final key in decoded.keys) {
      if (key is String && key.contains('_')) {
        throw FormatException(
          'Outbox payload violates the backend contract: camelCase-only keys are required. Found snake_case key: $key. There is no backward-compatibility path for snake_case payloads.',
        );
      }
    }

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return Map<String, dynamic>.from(decoded);
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
