import 'package:obywatel_plus/features/chat/domain/message.dart';
import 'package:obywatel_plus/features/chat/domain/message_repository.dart';
import 'package:obywatel_plus/features/chat/core/chat_exceptions.dart';

class MessageService {
  final MessageRepository messageRepository;

  MessageService({required this.messageRepository});

  
  Future<List<Message>> getMessages(String chatId) async {
    try {
      return await messageRepository.getMessages(chatId);
    } catch (e) {
      throw ChatApiException(null, 'Nie udało się pobrać wiadomości: $e');
    }
  }

  
  Future<void> saveMessage(Message message) async {
    try {
      await messageRepository.saveMessage(message);
    } catch (e) {
      throw ChatStorageException('Nie udało się zapisać wiadomości: $e');
    }
  }

  
  Future<void> saveMessages(List<Message> messages) async {
    try {
      await messageRepository.saveMessages(messages);
    } catch (e) {
      throw ChatStorageException('Nie udało się zapisać wiadomości: $e');
    }
  }

  
  Future<List<Message>> getUnsyncedMessages(String chatId) async {
    try {
      return await messageRepository.getUnsyncedMessages(chatId);
    } catch (e) {
      throw ChatStorageException('Nie udało się pobrać wiadomości offline: $e');
    }
  }

  
  Future<void> markAsSynced(String messageId) async {
    try {
      await messageRepository.markAsSynced(messageId);
    } catch (e) {
      throw ChatStorageException(
        'Nie udało się oznaczyć wiadomości jako wysłanej: $e',
      );
    }
  }

  
  Future<void> deleteMessage(String messageId) async {
    try {
      await messageRepository.deleteMessage(messageId);
    } catch (e) {
      throw ChatStorageException('Nie udało się usunąć wiadomości: $e');
    }
  }
}
