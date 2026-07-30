import 'dart:async';

import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/features/chats/data/datasources/chats_ws_client.dart';
import 'package:obywatel_plus/features/chats/data/dtos/message_dto.dart';
import 'package:obywatel_plus/features/chats/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/chats/domain/models/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'websocket_message_handler.g.dart';

class WebSocketMessageHandler {
  final ChatsWsClient _wsClient;
  final ChatsRepositoryImpl _repository;
  final AppLogger _logger;
  StreamSubscription<Map<String, dynamic>>? _subscription;

  WebSocketMessageHandler(this._wsClient, this._repository, this._logger);

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
          final dto = MessageDto.fromJson(json['data'] as Map<String, dynamic>);
          final message = Message(
            id: dto.id,
            conversationId: dto.conversationId,
            senderId: dto.senderId,
            content: dto.encryptedPayload,
            isMine: false,
            createdAt: dto.createdAt,
          );
          _repository.handleIncomingMessage(message);
          break;
        default:
          _logger.i('Nieznany typ wiadomości WS: $type', module: 'WSHandler');
      }
    } catch (e, st) {
      _logger.e(
        'Parsowanie wiadomości WS nie powiodło się',
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
  final repo = ref.watch(chatsRepositoryProvider) as ChatsRepositoryImpl;
  final logger = ref.watch(appLoggerProvider);

  final handler = WebSocketMessageHandler(wsClient, repo, logger);
  handler.init();

  ref.onDispose(() => handler.dispose());
  return handler;
}
