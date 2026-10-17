import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/clients/app_websocket_client.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/communication/application/outbox/outbox_processor.dart';
import 'package:obywatel_plus/features/communication/application/sync_status.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_ws_client.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/repositories/chats_repository.dart';

class ChatSyncService {
  final ChatsApiClient _apiClient;
  final ChatsWsClient _wsClient;
  final ChatsRepository _repository;
  final AppLogger _logger;
  final OutboxProcessor _outboxProcessor;
  final void Function(SyncStatus status) _updateStatus;

  StreamSubscription<WsConnectionStatus>? _statusSubscription;
  bool _isSyncing = false;
  SyncStatus _currentStatus = SyncStatus.idle;

  ChatSyncService(
    this._apiClient,
    this._wsClient,
    this._repository,
    this._logger,
    DeviceInfoService? deviceInfoService,
    void Function(SyncStatus status) updateStatus, {
    OutboxProcessor? outboxProcessor,
  }) : _updateStatus = updateStatus,
       _outboxProcessor =
           outboxProcessor ??
           OutboxProcessor(
             _repository,
             _apiClient,
             _logger,
             deviceInfoService ?? DeviceInfoService(_logger),
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
    await _outboxProcessor.processPending();
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
  final outboxProcessor = ref.read(outboxProcessorProvider);

  final service = ChatSyncService(
    apiClient,
    wsClient,
    repository,
    logger,
    deviceInfoService,
    syncStatus.update,
    outboxProcessor: outboxProcessor,
  );
  service.init();

  ref.onDispose(() => service.dispose());
  return service;
});
