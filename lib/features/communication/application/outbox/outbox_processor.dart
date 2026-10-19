import 'dart:convert';

import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/communication/application/outbox/outbox_transport_client.dart';
import 'package:obywatel_plus/features/communication/application/outbox_event_builder.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_utils.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:obywatel_plus/features/communication/domain/repositories/chats_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'outbox_processor.g.dart';

class OutboxMessageEvent {
  const OutboxMessageEvent({
    required this.id,
    required this.messageId,
    required this.conversationId,
    required this.ciphertext,
    required this.signalType,
    required this.eventId,
    required this.createdAt,
    this.senderDeviceId,
  });

  final String id;
  final String messageId;
  final String conversationId;
  final String ciphertext;
  final int signalType;
  final String eventId;
  final DateTime createdAt;
  final String? senderDeviceId;

  factory OutboxMessageEvent.fromJson(
    Map<String, dynamic> json, {
    required String localId,
  }) {
    final rawEventId = _readRequiredString(json, 'eventId');
    final rawMessageId = _readOptionalString(json, 'messageId') ?? rawEventId;
    final rawConversationId = _readRequiredString(json, 'conversationId');
    final rawCiphertext = _readRequiredString(json, 'ciphertext');
    final rawCreatedAt = _readRequiredString(json, 'createdAt');

    final messageId = rawMessageId.trim();
    if (messageId.isEmpty) {
      throw const FormatException('Outbox payload is missing eventId.');
    }

    final conversationId = rawConversationId.trim();
    if (conversationId.isEmpty ||
        !Uuid.isValidUUID(fromString: conversationId)) {
      throw const FormatException(
        'Outbox payload is missing a valid conversationId UUID.',
      );
    }

    final ciphertext = rawCiphertext.trim();
    if (ciphertext.isEmpty) {
      throw const FormatException('Outbox payload is missing ciphertext.');
    }

    final signalType = _readSignalType(json, 'type');
    final createdAt = normalizeTransportTimestamp(
      parseTransportTimestamp(rawCreatedAt),
    );
    final eventId = rawEventId.trim();
    if (eventId.isEmpty) {
      throw const FormatException('Outbox payload is missing eventId.');
    }

    return OutboxMessageEvent(
      id: localId,
      messageId: messageId,
      conversationId: conversationId,
      ciphertext: ciphertext,
      signalType: signalType,
      eventId: eventId,
      createdAt: createdAt,
      senderDeviceId: _readOptionalString(json, 'senderDeviceId'),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'eventId': eventId,
      'idempotencyKey': eventId,
      'messageId': messageId,
      'conversationId': conversationId,
      if (senderDeviceId != null && senderDeviceId!.trim().isNotEmpty)
        'senderDeviceId': senderDeviceId,
      'ciphertext': ciphertext,
      'type': signalType,
      'createdAt': createdAt.toUtc().toIso8601String(),
    };
  }

  static String _readRequiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String) {
      throw FormatException('Outbox payload is missing required field: $key.');
    }
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw FormatException('Outbox payload is missing required field: $key.');
    }
    return normalized;
  }

  static String? _readOptionalString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value == null) {
      return null;
    }
    final normalized = value.toString().trim();
    return normalized.isEmpty ? null : normalized;
  }

  static int _readSignalType(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is int) {
      if (value <= 0) {
        throw const FormatException(
          'Outbox payload is missing a valid signalType.',
        );
      }
      return value;
    }
    if (value is String) {
      final parsed = int.tryParse(value.trim());
      if (parsed != null && parsed > 0) {
        return parsed;
      }
    }
    throw const FormatException(
      'Outbox payload is missing a valid signalType.',
    );
  }
}

class _QueuedOutboxMessage {
  const _QueuedOutboxMessage(this.message, this.event);

  final Message message;
  final OutboxMessageEvent event;
}

class OutboxProcessor {
  OutboxProcessor(
    this._repository,
    this._transport,
    this._logger,
    this._deviceInfoService,
  );

  final ChatsRepository _repository;
  final OutboxTransportClient _transport;
  final AppLogger _logger;
  final DeviceInfoService _deviceInfoService;

  Future<void> processPending() async {
    final pendingMessages = await _repository.getPendingOutboxMessages();
    if (pendingMessages.isEmpty) return;

    final retryEligibleEvents = await _repository
        .getRetryEligibleOutboxEvents();
    final eventsByMessageId = <String, List<OutboxMessageEvent>>{};
    final invalidEventIds = <String>{};

    for (final event in retryEligibleEvents) {
      if (event.payload.trim().isEmpty) {
        invalidEventIds.add(event.id);
        continue;
      }

      try {
        final decoded = jsonDecode(event.payload);
        if (decoded is Map) {
          final payloadMap = <String, Object?>{};
          for (final entry in decoded.entries) {
            final key = entry.key?.toString();
            if (key != null && key.isNotEmpty) {
              payloadMap[key] = entry.value;
            }
          }

          final parsed = OutboxMessageEvent.fromJson(
            payloadMap,
            localId: event.id,
          );
          eventsByMessageId
              .putIfAbsent(parsed.messageId, () => <OutboxMessageEvent>[])
              .add(parsed);
        } else {
          invalidEventIds.add(event.id);
        }
      } catch (error, stackTrace) {
        invalidEventIds.add(event.id);
        _logger.w(
          '[OUTBOX-PROCESSOR-INVALID-JSON] malformed retry payload skipped. outbox_event_id=${event.id} message_id=${event.id}',
          error: error,
          stackTrace: stackTrace,
          module: 'OutboxProcessor',
        );
      }
    }

    if (invalidEventIds.isNotEmpty) {
      await _repository.deleteInvalidOutboxEvents(invalidEventIds.toList());
      _logger.i(
        '[OUTBOX-PROCESSOR] dropped ${invalidEventIds.length} invalid retry payloads from outbox',
        module: 'OutboxProcessor',
      );
    }

    final queuedMessages = <_QueuedOutboxMessage>[];
    final invalidMessageIds = <String>{};

    for (final message in pendingMessages) {
      final messageId = message.id.trim();
      if (messageId.isEmpty || !Uuid.isValidUUID(fromString: messageId)) {
        invalidMessageIds.add(message.id);
        _logger.w(
          '[OUTBOX-PROCESSOR-INVALID-MESSAGE] dropping pending entry with invalid message UUID. message_id=${message.id}',
          module: 'OutboxProcessor',
        );
        continue;
      }

      final conversationId = message.conversationId.trim();
      if (conversationId.isEmpty ||
          !Uuid.isValidUUID(fromString: conversationId)) {
        _logger.w(
          '[OUTBOX-PROCESSOR-HOLD] pending entry waits for valid conversationId. message_id=${message.id} conversationId=${message.conversationId}',
          module: 'OutboxProcessor',
        );
        continue;
      }

      if (message.encryptedPayload.trim().isEmpty) {
        invalidMessageIds.add(message.id);
        _logger.w(
          '[OUTBOX-PROCESSOR-INVALID-MESSAGE] dropping pending entry without ciphertext. message_id=${message.id}',
          module: 'OutboxProcessor',
        );
        continue;
      }

      final matchingEvents =
          eventsByMessageId[messageId] ?? const <OutboxMessageEvent>[];
      if (matchingEvents.isEmpty) {
        _logger.w(
          '[OUTBOX-PROCESSOR-HOLD] pending message has no matching retry payload metadata. message_id=${message.id}',
          module: 'OutboxProcessor',
        );
        continue;
      }
      if (matchingEvents.length > 1) {
        _logger.w(
          '[OUTBOX-PROCESSOR-DUPLICATE-EVENT] multiple Outbox events matched one messageId; using first event and preserving remaining rows. message_id=${message.id} candidates=${matchingEvents.length}',
          module: 'OutboxProcessor',
        );
      }

      queuedMessages.add(_QueuedOutboxMessage(message, matchingEvents.first));
    }

    if (invalidMessageIds.isNotEmpty) {
      await _repository.deleteInvalidOutboxEvents(invalidMessageIds.toList());
    }

    if (queuedMessages.isEmpty) {
      return;
    }

    final deviceId = await _deviceInfoService.getOrCreateDeviceId();
    final payload = <Map<String, dynamic>>[];
    final transportTargets = <_QueuedOutboxMessage>[];

    for (final queued in queuedMessages) {
      try {
        final candidate = messageToOutboxJson(
          queued.message,
          deviceId,
          signalType: queued.event.signalType,
          outboxEventId: queued.event.eventId,
        );
        payload.add(candidate);
        transportTargets.add(queued);
      } catch (error, stackTrace) {
        _logger.w(
          '[OUTBOX-PROCESSOR-INVALID-MESSAGE] unable to build payload for pending message. message_id=${queued.message.id}',
          error: error,
          stackTrace: stackTrace,
          module: 'OutboxProcessor',
        );
      }
    }

    if (payload.isEmpty) {
      return;
    }

    try {
      await _transport.sendOutboxBatch(payload);
      await _repository.clearSentOutboxMessages(
        transportTargets.map((entry) => entry.message.id).toList(),
      );
    } catch (error, stackTrace) {
      for (final queued in transportTargets) {
        final current = await _repository.getOutboxEventById(queued.message.id);
        final retryCount = (current?.retryCount ?? 0) + 1;
        await _repository.scheduleOutboxRetry(
          queued.message.id,
          retryCount: retryCount,
        );
      }
      _logger.w(
        '[OUTBOX-PROCESSOR-RETRY] batch send failed; retry scheduled for attempted transport entries.',
        error: error,
        stackTrace: stackTrace,
        module: 'OutboxProcessor',
      );
      rethrow;
    }
  }
}

@riverpod
OutboxProcessor outboxProcessor(Ref ref) {
  return OutboxProcessor(
    ref.watch(chatsRepositoryProvider),
    ref.watch(chatsApiClientProvider),
    ref.watch(appLoggerProvider),
    ref.watch(deviceInfoServiceProvider),
  );
}
