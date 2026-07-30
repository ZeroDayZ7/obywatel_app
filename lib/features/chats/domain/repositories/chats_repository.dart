import 'package:obywatel_plus/features/chats/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/chats/domain/models/conversation.dart';
import 'package:obywatel_plus/features/chats/domain/models/message.dart';

abstract class ChatsRepository {
  Future<List<Conversation>> getConversations();
  Future<List<Message>> getMessageHistory(
    String conversationId, {
    String? beforeId,
    int limit = 50,
  });
  Future<void> sendMessage({
    required String conversationId,
    required String content,
  });
  Stream<Message> get incomingMessagesStream;

  /// Pobiera niepotwierdzone wiadomości z lokalnego outboxa (dla offline sync)
  Future<List<Message>> getPendingOutboxMessages();

  /// Usuwa wysłane wiadomości z lokalnej kolejki outbox po udanej synchronizacji
  Future<void> clearSentOutboxMessages(List<String> messageIds);

  /// Zapisuje i aktualizuje listę konwersacji pobraną z serwera
  Future<List<Conversation>> saveConversationsFromRemote(
    List<ConversationDto> dtos,
  );
}
