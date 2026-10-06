import 'dart:async';

import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/features/chats/application/chat_sync_service.dart';
import 'package:obywatel_plus/features/chats/data/datasources/chats_ws_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'websocket_message_handler.g.dart';

class WebSocketMessageHandler {
  final ChatsWsClient _wsClient;
  final AppLogger _logger;
  final Future<void> Function() _onSignalReceived;
  StreamSubscription<Map<String, dynamic>>? _subscription;

  WebSocketMessageHandler(
    this._wsClient,
    this._logger,
    this._onSignalReceived,
  );

  void init() {
    _subscription = _wsClient.rawMessagesStream.listen(
      _handleRawMessage,
      onError: (error) {
        _logger.e(
          'Błąd na strumieniu WebSocket',
          error: error,
          module: 'WSHandler',
        );
      },
    );
  }

  void _handleRawMessage(Map<String, dynamic> json) {
    try {
      final type = json['type'] as String?;

      switch (type) {
        case 'new_message':
        case 'conversation_updated':
        case 'contact_updated':
          _logger.i(
            'Odebrano sygnał WS typu $type. Uruchamianie delta sync.',
            module: 'WSHandler',
          );
          unawaited(_onSignalReceived());
          break;
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
    () async {
      await ref.read(chatSyncServiceProvider).syncPendingData();
    },
  );
  handler.init();

  ref.onDispose(() => handler.dispose());
  return handler;
}
