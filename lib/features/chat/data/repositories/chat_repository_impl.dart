import 'dart:async';
import 'dart:io' show WebSocket;

import '../../domain/models/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../remote/chat_api.dart';
import '../../application/message/message_service.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatApi api;
  final MessageService messageService;

  ChatRepositoryImpl({required this.api, required this.messageService});

  // StreamController tylko dla opcjonalnego broadcasta w repo
  final _messagesController = StreamController<Message>.broadcast();
  Stream<Message> get messagesStream => _messagesController.stream;

  WebSocket? _socket;

  // ============================================================
  // FETCH HISTORY
  // ============================================================
  @override
  Future<List<Message>> fetchMessages(String chatId) async {
    final dtos = await api.fetchMessages(chatId);
    final messages = dtos.map((dto) => Message.fromDto(dto)).toList();
    return messages;
  }

  // ============================================================
  // CONNECT WEBSOCKET
  // ============================================================
  Future<void> connectWebSocket(String chatId, String token) async {
    final url = api.wsUrl(chatId, token);
    _socket = await WebSocket.connect(url);

    _socket!.listen(
      (data) async {
        final msg = await messageService.handleIncoming(data, chatId);
        _messagesController.add(msg);
      },
      onError: (err) {
        // np. reconnect logic można dodać tutaj
      },
      onDone: () {
        // np. reconnect logic można dodać tutaj
      },
    );
  }

  // ============================================================
  // SEND MESSAGE
  // ============================================================
  Future<void> sendMessage(String chatId, Message msg) async {
    if (_socket == null) return;
    final encrypted = await messageService.encryptMessage(msg.text, chatId);
    _socket!.add(messageService.wrapOutgoing(msg, encrypted));
    _messagesController.add(msg);
    await messageService.saveLocal(msg);
  }

  // ============================================================
  // CLOSE
  // ============================================================
  void dispose() {
    _socket?.close();
    _messagesController.close();
  }
}
