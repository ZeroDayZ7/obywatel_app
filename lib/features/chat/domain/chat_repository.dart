import 'package:obywatel_plus/features/chat/domain/chat.dart';
import 'package:obywatel_plus/features/chat/domain/message.dart';

abstract class ChatRepository {
  
  Future<Chat> getChat(String chatId);

  
  Future<List<Message>> getMessages(String chatId);

  
  
  
  
  Future<dynamic> connectWebSocket({
    required String chatId,
    required String token,
  });

  
  Future<void> sendMessage(Message message);

  
  Future<void> syncOfflineMessages(String chatId, List<Message> messages);
}
