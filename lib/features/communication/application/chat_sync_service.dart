import 'dart:async';
import 'dart:io';

import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/clients/app_websocket_client.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/auth/domain/auth_state.dart';
import 'package:obywatel_plus/features/communication/application/outbox/outbox_processor.dart';
import 'package:obywatel_plus/features/communication/application/sync_status.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_ws_client.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/repositories/chats_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_sync_service.g.dart';

class ChatSyncService {
  ChatSyncService(
    this._apiClient,
    this._wsClient,
    this._repository,
    this._logger,
    this._updateStatus, {
    required OutboxProcessor outboxProcessor,
  }) : _outboxProcessor = outboxProcessor;

  final ChatsApiClient _apiClient;
  final ChatsWsClient _wsClient;
  final ChatsRepository _repository;
  final AppLogger _logger;
  final OutboxProcessor _outboxProcessor;
  final void Function(SyncStatus status) _updateStatus;

  StreamSubscription<WsConnectionStatus>? _statusSubscription;
  bool _isSyncing = false;
  bool _isStarted = false;
  bool _isDisposed = false;
  int _generation = 0;
  SyncStatus _currentStatus = SyncStatus.idle;

  SyncStatus get currentStatus => _currentStatus;

  bool _isGenerationActive(int generation) {
    return !_isDisposed && generation == _generation;
  }

  void _setCurrentStatus(SyncStatus status, {int? generation}) {
    if (_isDisposed || (generation != null && generation != _generation)) {
      return;
    }
    _currentStatus = status;
    _updateStatus(status);
  }

  void startSession() {
    if (_isDisposed || _isStarted) {
      return;
    }

    _isStarted = true;
    _generation++;
    _statusSubscription ??= _wsClient.statusStream.listen(_onStatusChanged);
  }

  void stopSession() {
    _generation++;
    _isStarted = false;
    _isSyncing = false;
    _statusSubscription?.cancel();
    _statusSubscription = null;
    if (!_isDisposed) {
      _currentStatus = SyncStatus.idle;
      _updateStatus(SyncStatus.idle);
    }
  }

  void init() => startSession();

  void _onStatusChanged(WsConnectionStatus status) {
    if (_isDisposed || !_isStarted) {
      return;
    }

    if (status == WsConnectionStatus.connected) {
      _logger.i(
        'Połączenie WS nawiązane. Uruchamianie synchronizacji...',
        module: 'ChatSync',
      );
      unawaited(syncPendingData());
    }
  }

  Future<void> syncPendingData() async {
    if (_isDisposed || _isSyncing) {
      return;
    }

    final generation = _generation;
    _isSyncing = true;
    _setCurrentStatus(SyncStatus.syncing, generation: generation);

    try {
      await _flushOutbox();
      if (!_isGenerationActive(generation)) return;

      await _fetchDeltaSync();
      if (!_isGenerationActive(generation)) return;

      await _fetchLatestConversations();
      if (!_isGenerationActive(generation)) return;

      _setCurrentStatus(SyncStatus.idle, generation: generation);
    } on SocketException {
      if (!_isGenerationActive(generation)) return;
      _setCurrentStatus(SyncStatus.offline, generation: generation);
      _logger.w(
        'Brak połączenia z serwerem. Tryb offline.',
        module: 'ChatSync',
      );
    } catch (e, st) {
      if (!_isGenerationActive(generation)) return;
      _setCurrentStatus(SyncStatus.error, generation: generation);
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
    _isDisposed = true;
    stopSession();
  }
}

@riverpod
class ChatSyncStatusController extends _$ChatSyncStatusController {
  @override
  SyncStatus build() => SyncStatus.idle;

  void update(SyncStatus status) {
    state = status;
  }
}

@Riverpod(keepAlive: true)
ChatSyncService chatSyncService(Ref ref) {
  final apiClient = ref.watch(chatsApiClientProvider);
  final wsClient = ref.watch(chatsWsClientProvider);
  final repository = ref.watch(chatsRepositoryProvider);
  final logger = ref.watch(appLoggerProvider);
  final syncStatus = ref.read(chatSyncStatusControllerProvider.notifier);
  final outboxProcessor = ref.read(outboxProcessorProvider);

  final service = ChatSyncService(
    apiClient,
    wsClient,
    repository,
    logger,
    syncStatus.update,
    outboxProcessor: outboxProcessor,
  );

  ref.listen<AuthState>(authControllerProvider, (_, next) {
    if (next.isAuthenticated) {
      service.startSession();
    } else {
      service.stopSession();
    }
  });

  final initialState = ref.read(authControllerProvider);
  if (initialState.isAuthenticated) {
    service.startSession();
  }

  ref.onDispose(() => service.dispose());
  return service;
}
