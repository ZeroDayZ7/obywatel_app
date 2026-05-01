import 'package:obywatel_plus/features/chat/domain/message.dart';

/// Repository odpowiedzialne WYŁĄCZNIE za warstwę danych lokalnych:
/// - zapis wiadomości offline
/// - odczyt wiadomości
/// - synchronizacja z backendem (REST/WebSocket)
///
/// Zero logiki sieciowej (to robi ChatRepository).
abstract class MessageRepository {
  /// Zapisuje jedną wiadomość lokalnie (np. SQLite / Hive).
  Future<void> saveMessage(Message message);

  /// Zapisuje wiele wiadomości naraz – szybka synchronizacja.
  Future<void> saveMessages(List<Message> messages);

  /// Pobiera wszystkie wiadomości z danego czatu.
  Future<List<Message>> getMessages(String chatId);

  /// Oznacza wiadomość jako wysłaną / zsynchronizowaną.
  Future<void> markAsSynced(String messageId);

  /// Pobiera wiadomości, które nie zostały wysłane (offline queue).
  Future<List<Message>> getUnsyncedMessages(String chatId);

  /// Usuwa wiadomość lokalnie (jeśli to konieczne).
  Future<void> deleteMessage(String messageId);
}
