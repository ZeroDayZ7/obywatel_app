import 'package:obywatel_plus/features/communication/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/communication/domain/chats/conversation.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';

abstract class ChatsRepository {
  Stream<List<Conversation>> watchConversations();
  Stream<List<Message>> watchMessagesForConversation(String conversationId);

  Future<List<Conversation>> getConversations();
  Future<String> ensureConversationForContact(
    String contactUserId, {
    String? title,
  });
  Future<void> ensureE2eeSessionForContact(String contactUserId);
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

  /// Synchronicznie pobiera i aplikuje delta sync z backendu.
  Future<List<Map<String, dynamic>>> syncDeltaFromRemote({
    int lastKnownContactVersion = 0,
    int lastKnownMessageVersion = 0,
  });

  /// Usuwa wysłane wiadomości z lokalnej kolejki outbox po udanej synchronizacji
  Future<void> clearSentOutboxMessages(List<String> messageIds);

  /// Zapisuje i aktualizuje listę konwersacji pobraną z serwera
  Future<List<Conversation>> saveConversationsFromRemote(
    List<ConversationDto> dtos,
  );
}
