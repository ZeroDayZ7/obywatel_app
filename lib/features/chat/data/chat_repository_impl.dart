import 'dart:async';
import 'package:obywatel_plus/features/chat/data/chat_api.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:obywatel_plus/features/chat/domain/chat.dart';
import 'package:obywatel_plus/features/chat/domain/message.dart';
import 'package:obywatel_plus/features/chat/domain/chat_repository.dart';
import 'package:obywatel_plus/features/chat/application/message_service.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatApi api;
  final MessageService messageService;

  ChatRepositoryImpl({required this.api, required this.messageService});

  WebSocketChannel? _socket;
  final _messagesController = StreamController<Message>.broadcast();

  
  Stream<Message> get messagesStream => _messagesController.stream;

  
  
  
  @override
  Future<Chat> getChat(String chatId) async {
    
    
    return Chat(
      id: chatId,
      name: 'Czat $chatId',
      participants: const [],
      avatarUrl: null,
      createdAt: DateTime.now(),
    );
  }

  
  
  
  @override
  Future<List<Message>> getMessages(String chatId) async {
    
    final msgs = await api.getChatMessages(chatId);
    return msgs;
  }

  
  
  
  @override
  Future<WebSocketChannel> connectWebSocket({
    required String chatId,
    required String token,
  }) async {
    _socket = await api.connectWebSocket(chatId: chatId, token: token);

    _socket!.stream.listen(
      (data) {
        
        
        final message = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          chatId: chatId,
          senderId: 'server',
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

  
  
  
  @override
  Future<void> sendMessage(Message message) async {
    
    await api.sendMessage(message.chatId, message);

    
    if (_socket != null) {
      _socket!.sink.add(message.text);
    }

    
    await messageService.saveMessage(message);

    
    _messagesController.add(message);
  }

  
  
  
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

  
  
  
  void dispose() {
    _socket?.sink.close();
    _messagesController.close();
  }
}
