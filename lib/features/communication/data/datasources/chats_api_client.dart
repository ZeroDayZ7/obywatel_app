import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/features/communication/data/dtos/attachment_dto.dart';
import 'package:obywatel_plus/features/communication/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/communication/data/dtos/message_dto.dart';
import 'package:obywatel_plus/features/communication/data/dtos/message_envelope.dart';
import 'package:obywatel_plus/features/communication/data/dtos/message_record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chats_api_client.g.dart';

class ChatsApiClient {
  final ApiClient _apiClient;

  const ChatsApiClient(this._apiClient);

  Future<List<ConversationDto>> getConversations() async {
    final response = await _apiClient.get(ApiEndpoints.conversations);
    final data = response.data as List<dynamic>;

    return data
        .map((json) => ConversationDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<MessageDto>> getMessageHistory(
    String conversationId, {
    String? beforeId,
    int limit = 50,
  }) async {
    final queryParams = <String, dynamic>{'limit': limit, 'beforeId': beforeId};

    final response = await _apiClient.get(
      ApiEndpoints.conversationMessages(conversationId),
      queryParams: queryParams,
    );

    final data = response.data as List<dynamic>;

    return data
        .map((json) => MessageDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ConversationDto> createConversation({
    required String type,
    required List<String> recipientIds,
    String? title,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.conversations,
      data: {
        'type': type,
        'title': title ?? 'Kontakt',
        'recipientIds': recipientIds,
      },
    );

    final data = response.data as Map<String, dynamic>? ?? const {};
    return ConversationDto.fromJson(data);
  }

  Future<Response<dynamic>> post(String path, {dynamic data}) {
    return _apiClient.post(path, data: data);
  }

  Future<void> sendOutboxBatch(List<Map<String, dynamic>> payload) async {
    final requestBody = {'messages': payload};

    await _apiClient.post(ApiEndpoints.syncOutbox, data: requestBody);
  }

  Future<Map<String, dynamic>> syncDelta({
    int lastKnownContactVersion = 0,
    int lastKnownMessageVersion = 0,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.syncDelta,
      data: {
        'lastKnownContactVersion': lastKnownContactVersion,
        'lastKnownMessageVersion': lastKnownMessageVersion,
      },
    );

    final data = response.data as Map<String, dynamic>? ?? const {};
    return data;
  }

  Future<MessageEnvelope> sendMessageEnvelope(MessageEnvelope envelope) async {
    final response = await _apiClient.post(
      ApiEndpoints.messages,
      data: envelope.toJson(),
    );
    return MessageEnvelope.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );
  }

  Future<List<MessageRecord>> getMessageHistoryEnvelope({
    required String conversationId,
    int since = 0,
    int limit = 50,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.messageHistory,
      queryParams: {
        'conversationId': conversationId,
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

  Future<void> uploadDeviceKeys(Map<String, dynamic> payload) async {
    await _apiClient.post(ApiEndpoints.cryptoDeviceKeys, data: payload);
  }

  Future<Map<String, dynamic>> getUserPreKeys(String userId) async {
    final response = await _apiClient.get(ApiEndpoints.userPreKeys(userId));
    return response.data as Map<String, dynamic>;
  }

  Future<AttachmentUploadResponseDto> prepareAttachmentUpload({
    required String conversationId,
    required String fileName,
    required String contentType,
    required int size,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.attachmentUpload,
      data: {
        'conversationId': conversationId,
        'fileName': fileName,
        'contentType': contentType,
        'size': size,
      },
    );

    final payload = response.data as Map<String, dynamic>? ?? const {};
    return AttachmentUploadResponseDto.fromJson(payload);
  }

  Future<AttachmentDto> finalizeAttachmentUpload({
    required String attachmentId,
    required int size,
    String? sha256,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.attachmentFinalize,
      data: {
        'attachmentId': attachmentId,
        'size': size,
        if (sha256 != null && sha256.trim().isNotEmpty) 'sha256': sha256,
      },
    );

    final payload = response.data as Map<String, dynamic>? ?? const {};
    return AttachmentDto.fromJson(payload);
  }

  Future<AttachmentDto> getAttachment(String attachmentId) async {
    final response = await _apiClient.get(
      ApiEndpoints.attachmentById(attachmentId),
    );

    final payload = response.data as Map<String, dynamic>? ?? const {};
    return AttachmentDto.fromJson(payload);
  }

  Future<void> deleteAttachment(String attachmentId) async {
    await _apiClient.delete(ApiEndpoints.attachmentById(attachmentId));
  }
}

@riverpod
ChatsApiClient chatsApiClient(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ChatsApiClient(apiClient);
}
