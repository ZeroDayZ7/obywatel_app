import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/clients/app_websocket_client.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/chats/application/sync_status.dart';
import 'package:obywatel_plus/features/chats/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/chats/data/datasources/chats_ws_client.dart';
import 'package:obywatel_plus/features/chats/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/chats/domain/models/message.dart';

Map<String, dynamic> messageToOutboxJson(Message message, String deviceId) {
  return {
    'id': message.id,
    'conversation_id': message.conversationId,
    'event_type': 'SEND_MESSAGE',
    'sender_id': message.senderId,
    'device_id': deviceId,
    'content': message.content,
    'created_at': message.createdAt.toIso8601String(),
  };
}

class ChatSyncService {
  final ChatsApiClient _apiClient;
  final ChatsWsClient _wsClient;
  final ChatsRepositoryImpl _repository;
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
    _updateStatus(SyncStatus.syncing);

    try {
      await _flushOutbox();
      await _fetchDeltaSync();
      await _fetchLatestConversations();
      _currentStatus = SyncStatus.idle;
      _updateStatus(SyncStatus.idle);
    } on SocketException {
      _currentStatus = SyncStatus.offline;
      _updateStatus(SyncStatus.offline);
      _logger.w(
        'Brak połączenia z serwerem. Tryb offline.',
        module: 'ChatSync',
      );
    } catch (e, st) {
      _currentStatus = SyncStatus.error;
      _updateStatus(SyncStatus.error);
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

    final deviceId = await _deviceInfoService.getOrCreateDeviceId();

    _logger.i(
      'Wysyłanie ${pendingMessages.length} zaległych wiadomości z outboxa',
      module: 'ChatSync',
    );

    final payload = pendingMessages
        .map((message) => messageToOutboxJson(message, deviceId))
        .toList();

    await _apiClient.sendOutboxBatch(payload);
    await _repository.clearSentOutboxMessages(
      pendingMessages.map((m) => m.id).toList(),
    );
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
  final repository = ref.watch(chatsRepositoryProvider) as ChatsRepositoryImpl;
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
