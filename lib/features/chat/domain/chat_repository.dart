import 'package:obywatel_plus/features/chat/domain/chat.dart';
import 'package:obywatel_plus/features/chat/domain/message.dart';

abstract class ChatRepository {
  /// Pobiera informacje o czacie (np. nazwa, uczestnicy, avatar).
  Future<Chat> getChat(String chatId);

  /// Pobiera historię wiadomości z serwera (np. pierwsze 50).
  Future<List<Message>> getMessages(String chatId);

  /// Otwiera połączenie WebSocket dla danego czatu.
  ///
  /// [token] pobierasz z SessionService.
  /// Zwraca obiekt WebSocket lub adapter WebSocket z Twojej aplikacji.
  Future<dynamic> connectWebSocket({
    required String chatId,
    required String token,
  });

  /// Wysyła wiadomość na serwer REST (fallback / synchronizacja).
  Future<void> sendMessage(Message message);

  /// Synchronizuje wiadomości offline → online
  Future<void> syncOfflineMessages(String chatId, List<Message> messages);
}
