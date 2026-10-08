import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/features/communication/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/communication/data/dtos/message_dto.dart';
import 'package:obywatel_plus/features/communication/data/dtos/message_envelope.dart';
import 'package:obywatel_plus/features/communication/data/dtos/message_record.dart';
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
      'before_id': beforeId,
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

  /// Wysyła lokalny outbox do backendu w trybie offline-first.
  Future<void> sendOutboxBatch(List<Map<String, dynamic>> payload) async {
    await _apiClient.post(ApiEndpoints.syncOutbox, data: payload);
  }

  /// Pobiera i aplikuje zmiany różnicowe z ostatniego znanego stanu synchronizacji.
  Future<Map<String, dynamic>> syncDelta({
    int lastKnownContactVersion = 0,
    int lastKnownMessageVersion = 0,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.syncDelta,
      data: {
        'last_known_contact_version': lastKnownContactVersion,
        'last_known_message_version': lastKnownMessageVersion,
      },
    );

    final data = response.data as Map<String, dynamic>? ?? const {};
    return data;
  }

  /// Wysyła zaszyfrowaną kopertę do trwałego archiwum wiadomości.
  Future<MessageEnvelope> sendMessageEnvelope(MessageEnvelope envelope) async {
    final response = await _apiClient.post(
      ApiEndpoints.messages,
      data: envelope.toJson(),
    );
    return MessageEnvelope.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  /// Pobiera zaszyfrowaną historię konwersacji z archiwum po `since`.
  Future<List<MessageRecord>> getMessageHistoryEnvelope({
    required String conversationId,
    int since = 0,
    int limit = 50,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.messageHistory,
      queryParams: {
        'conversation_id': conversationId,
        'since': since,
        'limit': limit,
      },
    );

    final data = response.data as List<dynamic>? ?? const <dynamic>[];
    return data
        .map(
          (json) =>
              MessageRecord.fromJson(Map<String, dynamic>.from(json as Map)),
        )
        .toList();
  }

  /// Rejestruje klucze urządzenia dla mechanizmu E2EE / X3DH.
  Future<void> uploadDeviceKeys(Map<String, dynamic> payload) async {
    await _apiClient.post(ApiEndpoints.cryptoDeviceKeys, data: payload);
  }

  /// Pobiera klucze pre-key użytkownika dla protokołu X3DH / E2EE.
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
