// lib/features/chat/data/remote/chat_api.dart
import 'package:obywatel_plus/core/network/clients/api_client.dart' show ApiClient;
import 'package:obywatel_plus/features/chat/core/chat_endpoints.dart'
    show ChatEndpoints;
import 'package:obywatel_plus/features/chat/data/message_dto.dart';
import 'package:obywatel_plus/features/chat/domain/message.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatApi {
  final ApiClient client;

  ChatApi({required this.client});

  // REST – pobranie historii
  Future<List<Message>> getChatMessages(String chatId) async {
    final response = await client.get(ChatEndpoints.messages(chatId));

    final data = response.data as List<dynamic>;
    return data.map((json) => MessageDto.fromJson(json).toDomain()).toList();
  }

  // REST – wysyłanie wiadomości (opcjonalnie)
  Future<void> sendMessage(String chatId, Message message) async {
    final dto = MessageDto.fromDomain(message);
    await client.post(ChatEndpoints.sendMessage(chatId), data: dto.toJson());
  }

  // WS – połączenie WebSocket
  Future<WebSocketChannel> connectWebSocket({
    required String chatId,
    required String token,
  }) async {
    final url = '${ChatEndpoints.ws(chatId)}?token=$token';
    return WebSocketChannel.connect(Uri.parse(url));
  }
}
