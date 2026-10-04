import 'dart:io';

import 'package:dio/dio.dart';
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

  Future<T> _runWithRetry<T>(Future<T> Function() action) async {
    Object? lastError;

    for (var attempt = 0; attempt < 3; attempt++) {
      try {
        return await action();
      } on DioException catch (error) {
        lastError = error;
        final isConnectionError =
            error.type == DioExceptionType.connectionError ||
            error.type == DioExceptionType.connectionTimeout ||
            error.error is SocketException;

        if (!isConnectionError || attempt == 2) {
          rethrow;
        }
      } on SocketException catch (error) {
        lastError = error;
        if (attempt == 2) {
          rethrow;
        }
      }

      final delay = Duration(seconds: 1 << attempt);
      await Future<void>.delayed(delay);
    }

    throw lastError ?? const SocketException('Connection retry failed');
  }

  /// Pobiera listę konwersacji użytkownika
  Future<List<ConversationDto>> getConversations() async {
    return _runWithRetry(() async {
      final response = await _apiClient.get(ApiEndpoints.conversations);
      final data = response.data as List<dynamic>;

      return data
          .map((json) => ConversationDto.fromJson(json as Map<String, dynamic>))
          .toList();
    });
  }

  /// Pobiera historię wiadomości dla danej konwersacji (z paginacją/cursor)
  Future<List<MessageDto>> getMessageHistory(
    String conversationId, {
    String? beforeId,
    int limit = 50,
  }) async {
    return _runWithRetry(() async {
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
    });
  }

  /// Wysyła lokalny outbox do backendu w trybie offline-first.
  Future<void> sendOutboxBatch(List<Map<String, dynamic>> payload) async {
    await _runWithRetry(() async {
      await _apiClient.post(ApiEndpoints.syncOutbox, data: {'messages': payload});
    });
  }

  /// Pobiera i aplikuje zmiany różnicowe z ostatniego znanego stanu synchronizacji.
  Future<Map<String, dynamic>> syncDelta({
    int lastKnownContactVersion = 0,
    int lastKnownMessageVersion = 0,
  }) async {
    return _runWithRetry(() async {
      final response = await _apiClient.post(
        ApiEndpoints.syncDelta,
        data: {
          'last_known_contact_version': lastKnownContactVersion,
          'last_known_message_version': lastKnownMessageVersion,
        },
      );

      final data = response.data as Map<String, dynamic>? ?? const {};
      return data;
    });
  }

  /// Rejestruje klucze urządzenia dla mechanizmu E2EE / X3DH.
  Future<void> uploadDeviceKeys(Map<String, dynamic> payload) async {
    await _runWithRetry(() async {
      await _apiClient.post(ApiEndpoints.cryptoDeviceKeys, data: payload);
    });
  }

  /// Pobiera klucze pre-key użytkownika dla protokołu X3DH / E2EE.
  Future<Map<String, dynamic>> getUserPreKeys(String userId) async {
    return _runWithRetry(() async {
      final response = await _apiClient.get(ApiEndpoints.userPreKeys(userId));
      return response.data as Map<String, dynamic>;
    });
  }
}

// Top-level provider wygenerowany przez Riverpod Generator
@riverpod
ChatsApiClient chatsApiClient(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ChatsApiClient(apiClient);
}
