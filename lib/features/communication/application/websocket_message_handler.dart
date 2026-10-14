import 'dart:async';

import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/features/communication/application/chat_sync_service.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_ws_client.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/contacts_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'websocket_message_handler.g.dart';

class WebSocketMessageHandler {
  final ChatsWsClient _wsClient;
  final AppLogger _logger;
  final Future<void> Function(String type) _onSignalReceived;
  StreamSubscription<Map<String, dynamic>>? _subscription;

  WebSocketMessageHandler(
    this._wsClient,
    this._logger,
    this._onSignalReceived,
  );

  void init() {
    _subscription = _wsClient.rawMessagesStream.listen(
      handleIncomingMessage,
      onError: (error) {
        _logger.e(
          'Błąd na strumieniu WebSocket',
          error: error,
          module: 'WSHandler',
        );
      },
    );
  }

  Future<void> _handleIncomingMessageAsync(Map<String, dynamic> json) async {
    try {
      final type = (json['type'] ?? '').toString();
      if (type.isEmpty) {
        _logger.i('Pusty typ wiadomości WS', module: 'WSHandler');
        return;
      }

      switch (type) {
        case 'new_message':
        case 'conversation_updated':
        case 'contact_updated':
          _logger.i(
            'Odebrano sygnał WS typu $type. Uruchamianie odpowiedniej synchronizacji.',
            module: 'WSHandler',
          );
          await _onSignalReceived(type);
          return;
        default:
          _logger.i('Nieznany typ wiadomości WS: $type', module: 'WSHandler');
      }
    } catch (e, st) {
      _logger.e(
        'Obsługa sygnału WS nie powiodła się',
        error: e,
        stackTrace: st,
        module: 'WSHandler',
      );
    }
  }

  void handleIncomingMessage(Map<String, dynamic> json) {
    unawaited(_handleIncomingMessageAsync(json));
  }

  void dispose() {
    _subscription?.cancel();
  }
}

@riverpod
WebSocketMessageHandler webSocketMessageHandler(Ref ref) {
  final wsClient = ref.watch(chatsWsClientProvider);
  final logger = ref.watch(appLoggerProvider);

  final handler = WebSocketMessageHandler(
    wsClient,
    logger,
    (type) async {
      switch (type) {
        case 'contact_updated':
          await ref.read(contactsSyncProvider.notifier).sync();
          return;
        case 'new_message':
        case 'conversation_updated':
          await ref.read(chatSyncServiceProvider).syncPendingData();
          return;
        default:
          return;
      }
    },
  );
  handler.init();

  ref.onDispose(() => handler.dispose());
  return handler;
}
