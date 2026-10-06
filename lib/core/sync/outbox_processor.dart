import 'dart:async';
import 'dart:convert';

import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/features/notifications/data/notification_api.dart';
import 'package:obywatel_plus/features/notifications/domain/sync_batch_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'outbox_processor.g.dart';

@riverpod
class OutboxProcessor extends _$OutboxProcessor {
  @override
  FutureOr<void> build() async {}

  Future<void> processPending() async {
    final db = ref.read(appDatabaseProvider);
    final api = ref.read(notificationApiProvider);

    final pending = await db.outboxDao.getPendingEvents();
    final notificationEvents = pending.where((e) => e.eventType.startsWith('notification.')).toList();
    if (notificationEvents.isEmpty) return;

    final ids = notificationEvents.map((e) => e.id).toList();
    // mark as sending to avoid duplicate processing
    await db.outboxDao.markAsSending(ids);

    final dtos = notificationEvents.map((e) {
      final payload = (e.payload.isNotEmpty) ? jsonDecode(e.payload) as Map<String, dynamic> : <String, dynamic>{};
      return SyncEventDto(
        id: e.id,
        eventType: e.eventType,
        payload: Map<String, dynamic>.from(payload),
        createdAt: e.createdAt.toUtc().toIso8601String(),
      );
    }).toList();

    try {
      final resp = await api.syncBatch(dtos);
      if (resp.processedEventIds.isNotEmpty) {
        await db.outboxDao.deleteEventsByIds(resp.processedEventIds);
      }
      if (resp.failedEventIds != null && resp.failedEventIds!.isNotEmpty) {
        for (final id in resp.failedEventIds!) {
          await db.outboxDao.incrementRetryCount(id);
        }
      }
    } catch (_) {
      // on error, revert sending status by incrementing retry counts
      for (final id in ids) {
        await db.outboxDao.incrementRetryCount(id);
      }
    }
  }
}
