import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/features/chats/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/chats/data/dtos/message_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chats_api_client.g.dart';

class ChatsApiClient {
  final ApiClient _apiClient;

  const ChatsApiClient(this._apiClient);

  /// Pobiera listę konwersacji użytkownika
  Future<List<ConversationDto>> getConversations() async {
    final response = await _apiClient.get(ApiEndpoints.conversations);
    final data = response.data as List<dynamic>;

    return data
        .map((json) => ConversationDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Pobiera historię wiadomości dla danej konwersacji (z paginacją/cursor)
  Future<List<MessageDto>> getMessageHistory(
    String conversationId, {
    String? beforeId,
    int limit = 50,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      if (beforeId != null) 'before_id': beforeId,
    };

    final response = await _apiClient.get(
      ApiEndpoints.conversationMessages(conversationId),
      queryParams: queryParams,
    );

    final data = response.data as List<dynamic>;

    return data
        .map((json) => MessageDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Przesyła wiadomości z lokalnego Outboxa w trybie offline-first
  Future<void> sendOutboxBatch(List<Map<String, dynamic>> payload) async {
    await _apiClient.post(
      ApiEndpoints.syncOutbox,
      data: {'messages': payload},
    );
  }

  /// Pobiera klucze pre-key użytkownika dla protokołu X3DH / E2EE
  Future<Map<String, dynamic>> getUserPreKeys(String userId) async {
    final response = await _apiClient.get(ApiEndpoints.userPreKeys(userId));
    return response.data as Map<String, dynamic>;
  }
}

// Top-level provider wygenerowany przez Riverpod Generator
@riverpod
ChatsApiClient chatsApiClient(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ChatsApiClient(apiClient);
}