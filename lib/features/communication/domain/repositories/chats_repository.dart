import 'package:obywatel_plus/features/communication/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/communication/domain/chats/conversation.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:obywatel_plus/features/communication/domain/outbox/outbox_event.dart';

abstract class ChatsRepository {
  Stream<List<Conversation>> watchConversations();
  Stream<List<Message>> watchMessagesForConversation(String conversationId);

  Future<List<Conversation>> getConversations();
  Future<String> resolvePeerUserIdForConversation(String conversationId);
  Future<String> ensureSelfConversation();
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
  Future<void> markConversationAsRead(String conversationId);
  Future<void> sendMessage({
    required String conversationId,
    required String content,
    String? attachmentId,
  });
  Future<Map<String, dynamic>?> getAttachmentMetadata(String attachmentId);
  Future<String?> getAttachmentKey(String attachmentId);
  Future<void> saveAttachmentKey({
    required String attachmentId,
    required String attachmentKey,
  });
  Future<void> deleteAttachmentKey(String attachmentId);
  Future<void> saveAttachmentMetadata({
    required String attachmentId,
    String? messageId,
    String? originalFileName,
    String? mimeType,
    int sizeBytes = 0,
    String sha256 = '',
    String? localFilePath,
    String? thumbnailPath,
    String status = 'ready',
    bool isAvailableLocally = false,
    bool hasThumbnail = false,
  });
  Stream<Message> get incomingMessagesStream;

  /// Pobiera niepotwierdzone wiadomości z lokalnego outboxa (dla offline sync)
  Future<List<Message>> getPendingOutboxMessages();

  Future<List<OutboxEvent>> getRetryEligibleOutboxEvents({
    DateTime? referenceTime,
  });
  Future<void> deleteInvalidOutboxEvents(List<String> ids);
  Future<OutboxEvent?> getOutboxEventById(String id);
  Future<void> scheduleOutboxRetry(
    String id, {
    required int retryCount,
    DateTime? referenceTime,
  });

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
