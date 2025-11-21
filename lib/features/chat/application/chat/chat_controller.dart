import 'dart:async';
import 'dart:io';

import 'package:obywatel_plus/features/chat/domain/models/message.dart';
import 'package:obywatel_plus/features/chat/domain/models/chat.dart';
import 'package:obywatel_plus/features/chat/domain/repositories/chat_repository.dart';
import 'package:obywatel_plus/features/chat/domain/repositories/message_repository.dart';
import '../session/session_service.dart';
import '../message/message_service.dart';

/// Controller odpowiada za pełną logikę:
/// - nasłuch WebSocket
/// - szyfrowanie / deszyfrowanie wiadomości
/// - wysyłanie i odbieranie
/// - zapis offline + synchronizacja
/// - stream do UI
class ChatController {
  final ChatRepository chatRepository;
  final MessageRepository messageRepository;
  final MessageService messageService;
  final SessionService sessionService;

  ChatController({
    required this.chatRepository,
    required this.messageRepository,
    required this.messageService,
    required this.sessionService,
  });

  /// Stream wszystkich wiadomości
  final StreamController<List<Message>> _messagesController =
      StreamController.broadcast();

  Stream<List<Message>> get messagesStream => _messagesController.stream;

  WebSocket? _socket;
  List<Message> _cachedMessages = [];

  // ============================================================
  // INIT
  // ============================================================

  Future<void> init(String chatId) async {
    // Wczytaj wiadomości offline
    final offlineMessages = await messageRepository.getMessages(chatId);
    _cachedMessages = offlineMessages;
    _messagesController.add(_cachedMessages);

    // Połącz WebSocket
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
        final decrypted = messageService.decryptMessage(data);
        final msg = Message.fromJson(decrypted);

        // Zapis offline
        await messageRepository.saveMessage(msg);

        // Dodanie do cache
        _cachedMessages.add(msg);
        _messagesController.add(List.from(_cachedMessages));
      },
      onError: (err) => _handleSocketError(chatId, err),
      onDone: () => _handleSocketClosed(chatId),
    );
  }

  void _handleSocketClosed(String chatId) {
    // Auto reconnect po 3s
    Future.delayed(const Duration(seconds: 3), () {
      _connectWebSocket(chatId);
    });
  }

  void _handleSocketError(String chatId, dynamic err) {
    // Możesz dodać logowanie
    _handleSocketClosed(chatId);
  }

  // ============================================================
  // WYSYŁANIE WIADOMOŚCI
  // ============================================================

  Future<void> sendMessage(String chatId, String text) async {
    final userId = await sessionService.getUserId();

    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      chatId: chatId,
      senderId: userId,
      text: text,
      timestamp: DateTime.now(),
      isMe: true,
    );

    // Szyfrowanie
    final encrypted = messageService.encryptMessage(message.toJson());

    // Wysłanie WebSocketem
    _socket?.add(encrypted);

    // Zapis lokalny
    await messageRepository.saveMessage(message);

    // Odśwież UI
    _cachedMessages.add(message);
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
