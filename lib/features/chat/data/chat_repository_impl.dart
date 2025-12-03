import 'dart:async';
import 'package:obywatel_plus/features/chat/data/chat_api.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../domain/chat.dart';
import '../domain/message.dart';
import '../domain/chat_repository.dart';
import '../application/message_service.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatApi api;
  final MessageService messageService;

  ChatRepositoryImpl({required this.api, required this.messageService});

  WebSocketChannel? _socket;
  final _messagesController = StreamController<Message>.broadcast();

  // @override
  Stream<Message> get messagesStream => _messagesController.stream;

  // ============================================================
  // GET CHAT INFO
  // ============================================================
  @override
  Future<Chat> getChat(String chatId) async {
    // jeżeli w przyszłości dodasz endpoint — tutaj go podłączymy
    // na razie zwracamy pusty / tymczasowy obiekt
    return Chat(
      id: chatId,
      name: "Czat $chatId",
      participants: const [],
      avatarUrl: null,
      createdAt: DateTime.now(),
    );
  }

  // ============================================================
  // GET MESSAGES (REST)
  // ============================================================
  @override
  Future<List<Message>> getMessages(String chatId) async {
    // API ZWRACA JUŻ Message, NIE DTO
    final msgs = await api.getChatMessages(chatId);
    return msgs;
  }

  // ============================================================
  // CONNECT WEBSOCKET
  // ============================================================
  @override
  Future<WebSocketChannel> connectWebSocket({
    required String chatId,
    required String token,
  }) async {
    _socket = await api.connectWebSocket(chatId: chatId, token: token);

    _socket!.stream.listen(
      (data) {
        // Na razie WS zwraca raw string — brak parsera w MessageService
        // więc tylko logujemy/dummy message
        final message = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          chatId: chatId,
          senderId: "server",
          text: data.toString(),
          timestamp: DateTime.now(),
          isMe: false,
          status: MessageStatus.delivered,
          imageUrl: null,
          synced: true,
        );

        _messagesController.add(message);
      },
      onError: (err) {},
      onDone: () {},
    );

    return _socket!;
  }

  // ============================================================
  // SEND MESSAGE (REST + WS)
  // ============================================================
  @override
  Future<void> sendMessage(Message message) async {
    // 1. wyślij do REST
    await api.sendMessage(message.chatId, message);

    // 2. wyślij przez WebSocket (jeśli jest)
    if (_socket != null) {
      _socket!.sink.add(message.text);
    }

    // 3. zapisz lokalnie
    await messageService.saveMessage(message);

    // 4. wyemituj stream
    _messagesController.add(message);
  }

  // ============================================================
  // SYNC OFFLINE
  // ============================================================
  @override
  Future<void> syncOfflineMessages(
    String chatId,
    List<Message> messages,
  ) async {
    for (final msg in messages) {
      await api.sendMessage(chatId, msg);
      await messageService.markAsSynced(msg.id);
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================
  void dispose() {
    _socket?.sink.close();
    _messagesController.close();
  }
}
