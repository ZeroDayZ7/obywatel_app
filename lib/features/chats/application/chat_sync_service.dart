import 'dart:async';

import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/clients/app_websocket_client.dart';
import 'package:obywatel_plus/features/chats/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/chats/data/datasources/chats_ws_client.dart';
import 'package:obywatel_plus/features/chats/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/chats/domain/models/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_sync_service.g.dart';

/// Mapuje domenowy model [Message] na strukture JSON wymaganą przez Outbox API.
Map<String, dynamic> messageToOutboxJson(Message message) {
  return {
    'id': message.id,
    'conversation_id': message.conversationId,
    'content': message.content,
    'created_at': message.createdAt.toIso8601String(),
  };
}

class ChatSyncService {
  final ChatsApiClient _apiClient;
  final ChatsWsClient _wsClient;
  final ChatsRepositoryImpl _repository;
  final AppLogger _logger;

  StreamSubscription<WsConnectionStatus>? _statusSubscription;
  bool _isSyncing = false;

  ChatSyncService(
    this._apiClient,
    this._wsClient,
    this._repository,
    this._logger,
  );

  void init() {
    _statusSubscription = _wsClient.statusStream.listen(_onStatusChanged);
  }

  void _onStatusChanged(WsConnectionStatus status) {
    if (status == WsConnectionStatus.connected) {
      _logger.i(
        'Połączenie WS nawiązane. Uruchamianie synchronizacji...',
        module: 'ChatSync',
      );
      syncPendingData();
    }
  }

  /// Pełny cykl synchronizacji: opróżnienie Outboxa oraz dociągnięcie wiadomości z API.
  Future<void> syncPendingData() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      await _flushOutbox();
      await _fetchLatestConversations();
    } catch (e, st) {
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

  /// Wysyła wiadomości z kolejki offline (Outbox) do API.
  Future<void> _flushOutbox() async {
    final pendingMessages = await _repository.getPendingOutboxMessages();
    if (pendingMessages.isEmpty) return;

    _logger.i(
      'Wysyłanie ${pendingMessages.length} zaległych wiadomości z outboxa',
      module: 'ChatSync',
    );

    final payload = pendingMessages.map(messageToOutboxJson).toList();
    await _apiClient.sendOutboxBatch(payload);
    await _repository.clearSentOutboxMessages(
      pendingMessages.map((m) => m.id).toList(),
    );
  }

  /// Pobiera aktualną listę konwersacji i najnowsze wiadomości
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

@riverpod
ChatSyncService chatSyncService(Ref ref) {
  final apiClient = ref.watch(chatsApiClientProvider);
  final wsClient = ref.watch(chatsWsClientProvider);
  final repository = ref.watch(chatsRepositoryProvider) as ChatsRepositoryImpl;
  final logger = ref.watch(appLoggerProvider);

  final service = ChatSyncService(apiClient, wsClient, repository, logger);
  service.init();

  ref.onDispose(() => service.dispose());
  return service;
}
