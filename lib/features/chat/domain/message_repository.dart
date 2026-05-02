import 'package:obywatel_plus/features/chat/domain/message.dart';







abstract class MessageRepository {
  
  Future<void> saveMessage(Message message);

  
  Future<void> saveMessages(List<Message> messages);

  
  Future<List<Message>> getMessages(String chatId);

  
  Future<void> markAsSynced(String messageId);

  
  Future<List<Message>> getUnsyncedMessages(String chatId);

  
  Future<void> deleteMessage(String messageId);
}
