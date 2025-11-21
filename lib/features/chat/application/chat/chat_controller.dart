import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:obywatel_plus/features/chat/domain/models/message.dart';
import 'package:obywatel_plus/features/chat/domain/repositories/chat_repository.dart';
import 'package:obywatel_plus/features/chat/domain/repositories/message_repository.dart';
import 'package:obywatel_plus/features/chat/application/message/message_service.dart';
// import 'package:obywatel_plus/features/chat/session/session_service.dart';
import 'package:obywatel_plus/features/chat/crypto/message_crypto_service.dart';

class ChatController {
  final ChatRepository chatRepository;
  final MessageRepository messageRepository;
  final MessageCryptoService crypto; // <-- tu wstrzykujemy crypto
  final SessionService sessionService;

  ChatController({
    required this.chatRepository,
    required this.messageRepository,
    required this.crypto,
    required this.sessionService,
  });

  final StreamController<List<Message>> _messagesController =
      StreamController.broadcast();

  Stream<List<Message>> get messagesStream => _messagesController.stream;

  WebSocket? _socket;
  List<Message> _cachedMessages = [];

  // ============================================================
  // INIT
  // ============================================================
  Future<void> init(String chatId) async {
    final offline = await messageRepository.getMessages(chatId);
    _cachedMessages = offline;
    _messagesController.add(_cachedMessages);

    await _connectWebSocket(chatId);
  }

  // ============================================================
  // WEBSOCKET
  // ============================================================
  Future<void> _connectWebSocket(String chatId) async {
    final token = await sessionService.getToken();

    _socket = await chatRepository.connectWebSocket(
      chatId: chatId,
      token: token,
    );

    _socket!.listen(
      (data) async {
        // 1️⃣ Odszyfrowanie
        final decrypted = await crypto.decrypt(data);

        // 2️⃣ Konwersja na Message
        final msg = Message.fromJson(
          decrypted,
          currentUserId: await sessionService.getUserId(),
        );

        // 3️⃣ Zapis offline
        await messageRepository.saveMessage(msg);

        // 4️⃣ Cache + UI
        _cachedMessages.add(msg);
        _messagesController.add(List.from(_cachedMessages));
      },

      onError: (err) => _handleSocketError(chatId, err),
      onDone: () => _handleSocketClosed(chatId),
    );
  }

  void _handleSocketClosed(String chatId) {
    Future.delayed(const Duration(seconds: 3), () {
      _connectWebSocket(chatId);
    });
  }

  void _handleSocketError(String chatId, dynamic err) {
    _handleSocketClosed(chatId);
  }

  // ============================================================
  // WYSYŁANIE WIADOMOŚCI
  // ============================================================
  Future<void> sendMessage(String chatId, String text) async {
    final userId = await sessionService.getUserId();

    final msg = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      senderId: userId,
      text: text,
      timestamp: DateTime.now(),
      isMe: true,
      status: MessageStatus.sent,
      synced: false,
    );

    // 1️⃣ Szyfrowanie
    final encrypted = await crypto.encrypt(msg.toJson());

    // 2️⃣ Wysłanie
    _socket?.add(encrypted);

    // 3️⃣ Zapis lokalny
    await messageRepository.saveMessage(msg);

    // 4️⃣ UI
    _cachedMessages.add(msg);
    _messagesController.add(List.from(_cachedMessages));
  }

  // ============================================================
  // ZAMKNIĘCIE
  // ============================================================
  Future<void> dispose() async {
    await _messagesController.close();
    await _socket?.close();
  }
}
