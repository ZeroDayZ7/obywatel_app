import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/clients/app_websocket_client.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/communication/application/outbox_event_builder.dart';
import 'package:obywatel_plus/features/communication/application/sync_status.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_ws_client.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_utils.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:obywatel_plus/features/communication/domain/repositories/chats_repository.dart';
import 'package:uuid/uuid.dart';

Map<String, dynamic> messageToOutboxJson(
  Message message,
  String deviceId, {
  required int signalType,
  String? messageId,
  String? outboxEventId,
}) {
  final resolvedMessageId = (messageId != null && messageId.trim().isNotEmpty)
      ? messageId
      : message.id;
  final resolvedEventId =
      (outboxEventId != null && outboxEventId.trim().isNotEmpty)
      ? outboxEventId
      : message.id;

  return buildOutboxEventPayload(
    message.copyWith(id: resolvedMessageId),
    deviceId,
    encryptedContent: message.encryptedPayload,
    outboxEventId: resolvedEventId,
    signalType: signalType,
  );
}

class ChatSyncService {
  final ChatsApiClient _apiClient;
  final ChatsWsClient _wsClient;
  final ChatsRepository _repository;
  final AppLogger _logger;
  final DeviceInfoService _deviceInfoService;
  final void Function(SyncStatus status) _updateStatus;

  StreamSubscription<WsConnectionStatus>? _statusSubscription;
  bool _isSyncing = false;
  SyncStatus _currentStatus = SyncStatus.idle;

  ChatSyncService(
    this._apiClient,
    this._wsClient,
    this._repository,
    this._logger,
    this._deviceInfoService,
    this._updateStatus,
  );

  SyncStatus get currentStatus => _currentStatus;

  void _setCurrentStatus(SyncStatus status) {
    _currentStatus = status;
    _updateStatus(status);
  }

  void init() {
    _statusSubscription = _wsClient.statusStream.listen(_onStatusChanged);
  }

  void _onStatusChanged(WsConnectionStatus status) {
    if (status == WsConnectionStatus.connected) {
      _logger.i(
        'Połączenie WS nawiązane. Uruchamianie synchronizacji...',
        module: 'ChatSync',
      );
      unawaited(syncPendingData());
    }
  }

  Future<void> syncPendingData() async {
    if (_isSyncing) return;
    _isSyncing = true;
    _setCurrentStatus(SyncStatus.syncing);

    try {
      await _flushOutbox();
      await _fetchDeltaSync();
      await _fetchLatestConversations();
      _setCurrentStatus(SyncStatus.idle);
    } on SocketException {
      _setCurrentStatus(SyncStatus.offline);
      _logger.w(
        'Brak połączenia z serwerem. Tryb offline.',
        module: 'ChatSync',
      );
    } catch (e, st) {
      _setCurrentStatus(SyncStatus.error);
      _logger.e(
        'Błąd podczas synchronizacji czatu',
        error: e,
        stackTrace: st,
        module: 'ChatSync',
      );
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _flushOutbox() async {
    final pendingMessages = await _repository.getPendingOutboxMessages();
    if (pendingMessages.isEmpty) return;

    final rawOutboxEvents = await _repository.getRetryEligibleOutboxEvents();
    final rawPayloadByMessageId = <String, Map<String, dynamic>>{};
    for (final event in rawOutboxEvents) {
      if (event.payload.trim().isEmpty) {
        continue;
      }

      try {
        final decoded = jsonDecode(event.payload);
        if (decoded is Map) {
          rawPayloadByMessageId[event.id] = Map<String, dynamic>.from(decoded);
        }
      } catch (error, stackTrace) {
        _logger.w(
          '[OUTBOX-FLOW-INVALID-JSON] skipping malformed retry payload while preparing batch. message_id=${event.id}',
          error: error,
          stackTrace: stackTrace,
          module: 'ChatSync',
        );
      }
    }

    final invalidMessageIds = <String>[];
    final validMessages = <Message>[];

    for (final message in pendingMessages) {
      final trimmedConversationId = message.conversationId.trim();
      final hasConversationId = trimmedConversationId.isNotEmpty;
      final hasCiphertext = message.encryptedPayload.trim().isNotEmpty;
      final hasValidMessageUuid = Uuid.isValidUUID(fromString: message.id);
      final hasValidConversationUuid =
          hasConversationId &&
          Uuid.isValidUUID(fromString: trimmedConversationId);
      final isReadyForServerDelivery =
          hasConversationId &&
          hasCiphertext &&
          hasValidMessageUuid &&
          hasValidConversationUuid;

      if (!hasValidMessageUuid || (!hasCiphertext && !hasConversationId)) {
        _logger.w(
          '[OUTBOX-FLOW-3] irrecoverably invalid pending event detected and will be dropped: '
          'message_id=${message.id} conversationId=${message.conversationId} '
          'ciphertext_present=$hasCiphertext message_uuid=$hasValidMessageUuid '
          'conversationId_format_valid=$hasValidConversationUuid',
          module: 'ChatSync',
        );
        invalidMessageIds.add(message.id);
        continue;
      }

      if (!hasValidConversationUuid) {
        _logger.w(
          '[OUTBOX-FLOW-3] unresolved pending message held for later retry: '
          'message_id=${message.id} conversationId=${message.conversationId} '
          'ciphertext_present=$hasCiphertext message_uuid=$hasValidMessageUuid '
          'conversationId_format_valid=$hasValidConversationUuid',
          module: 'ChatSync',
        );
        continue;
      }

      if (!isReadyForServerDelivery) {
        _logger.w(
          '[OUTBOX-FLOW-3] pending message is not ready for delivery yet: '
          'message_id=${message.id} conversationId=${message.conversationId} '
          'ciphertext_present=$hasCiphertext message_uuid=$hasValidMessageUuid '
          'conversationId_format_valid=$hasValidConversationUuid',
          module: 'ChatSync',
        );
        continue;
      }

      validMessages.add(message);
    }

    if (invalidMessageIds.isNotEmpty) {
      await _repository.deleteInvalidOutboxEvents(invalidMessageIds);
      _logger.i(
        '[OUTBOX-FLOW-3.1] dropped ${invalidMessageIds.length} irrecoverably invalid pending entries from outbox',
        module: 'ChatSync',
      );
    }

    if (validMessages.isEmpty) {
      _logger.w(
        '[OUTBOX-FLOW-3.2] no valid pending outbox entries ready to flush; unresolved local entries remain queued for retry',
        module: 'ChatSync',
      );
      return;
    }

    final deviceId = await _deviceInfoService.getOrCreateDeviceId();

    _logger.i(
      'Wysyłanie ${validMessages.length} zaległych wiadomości z outboxa',
      module: 'ChatSync',
    );

    final payload = validMessages
        .map((message) {
          final metadata = rawPayloadByMessageId[message.id];
          final storedType = metadata?['type'];
          final storedEventId = metadata?['eventId'];

          final signalType = normalizeSignalType(storedType?.toString());
          if (signalType == null) {
            _logger.w(
              '[OUTBOX-FLOW-ERROR] Message missing required signal type. message_id=${message.id} conversationId=${message.conversationId}',
              module: 'ChatSync',
            );
            invalidMessageIds.add(message.id);
            return null;
          }

          return messageToOutboxJson(
            message,
            deviceId,
            signalType: signalType,
            outboxEventId: storedEventId?.toString(),
          );
        })
        .whereType<Map<String, dynamic>>()
        .toList();

    if (invalidMessageIds.isNotEmpty) {
      await _repository.deleteInvalidOutboxEvents(invalidMessageIds);
      _logger.i(
        '[OUTBOX-FLOW-3.1] dropped ${invalidMessageIds.length} invalid pending entries because signal type was missing or invalid',
        module: 'ChatSync',
      );
    }

    if (payload.isEmpty) {
      _logger.w(
        '[OUTBOX-FLOW-3.2] no valid pending outbox entries ready to flush after signal type validation; unresolved local entries remain queued for retry',
        module: 'ChatSync',
      );
      return;
    }

    try {
      await _apiClient.sendOutboxBatch(payload);
      await _repository.clearSentOutboxMessages(
        validMessages.map((m) => m.id).toList(),
      );
    } catch (e) {
      for (final message in validMessages) {
        final current = await _repository.getOutboxEventById(message.id);
        final retryCount = (current?.retryCount ?? 0) + 1;
        await _repository.scheduleOutboxRetry(
          message.id,
          retryCount: retryCount,
        );
      }
      rethrow;
    }
  }

  Future<void> _fetchDeltaSync() async {
    final delta = await _repository.syncDeltaFromRemote();
    if (delta.isEmpty) return;

    _logger.i(
      'Zaaplikowano ${delta.length} elementów z delta sync',
      module: 'ChatSync',
    );
  }

  Future<void> _fetchLatestConversations() async {
    _logger.i(
      'Pobieranie aktualnej listy konwersacji z REST API',
      module: 'ChatSync',
    );
    final conversations = await _apiClient.getConversations();
    await _repository.saveConversationsFromRemote(conversations);
  }

  void dispose() {
    _statusSubscription?.cancel();
  }
}

class ChatSyncStatusController extends Notifier<SyncStatus> {
  @override
  SyncStatus build() => SyncStatus.idle;

  void update(SyncStatus status) {
    state = status;
  }
}

final chatSyncStatusControllerProvider =
    NotifierProvider<ChatSyncStatusController, SyncStatus>(
      ChatSyncStatusController.new,
    );

final chatSyncServiceProvider = Provider<ChatSyncService>((ref) {
  final apiClient = ref.watch(chatsApiClientProvider);
  final wsClient = ref.watch(chatsWsClientProvider);
  final repository = ref.watch(chatsRepositoryProvider);
  final logger = ref.watch(appLoggerProvider);
  final deviceInfoService = ref.watch(deviceInfoServiceProvider);
  final syncStatus = ref.read(chatSyncStatusControllerProvider.notifier);

  final service = ChatSyncService(
    apiClient,
    wsClient,
    repository,
    logger,
    deviceInfoService,
    syncStatus.update,
  );
  service.init();

  ref.onDispose(() => service.dispose());
  return service;
});
