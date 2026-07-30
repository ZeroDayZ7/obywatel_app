import 'dart:async';

import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/features/chats/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/chats/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/chats/data/dtos/message_dto.dart';
import 'package:obywatel_plus/features/chats/domain/models/conversation.dart';
import 'package:obywatel_plus/features/chats/domain/models/message.dart';
import 'package:obywatel_plus/features/chats/domain/repositories/chats_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chats_repository_impl.g.dart';

/// Przekształca DTO wiadomości na domenowy model Message.
Message mapMessageFromDto(MessageDto dto, String currentUserId) {
  return Message(
    id: dto.id,
    conversationId: dto.conversationId,
    senderId: dto.senderId,
    content: dto.encryptedPayload,
    isMine: dto.senderId == currentUserId,
    createdAt: dto.createdAt,
  );
}

/// Przekształca DTO konwersacji na domenowy model Conversation.
Conversation mapConversationFromDto(ConversationDto dto, String currentUserId) {
  return Conversation(
    id: dto.id,
    type: dto.type,
    title: dto.title,
    lastSequence: dto.lastSequence,
    members: dto.members
        .map(
          (m) => ConversationMember(
            id: m.id,
            conversationId: m.conversationId,
            userId: m.userId,
            role: m.role,
            lastReadSequence: m.lastReadSequence,
          ),
        )
        .toList(),
    messages: dto.messages
        ?.whereType<MessageDto>()
        .map((m) => mapMessageFromDto(m, currentUserId))
        .toList(),
    updatedAt: dto.updatedAt ?? DateTime.now(),
  );
}

class ChatsRepositoryImpl implements ChatsRepository {
  final ChatsApiClient _apiClient;
  final StreamController<Message> _incomingMessagesController =
      StreamController.broadcast();
  final AppLogger _logger;

  // TODO: Pobieramy z AuthState / UserStorage
  final String _currentUserId = 'my_user_id';

  // Bufor podręczny dla wiadomości oczekujących na wysłanie (Outbox pattern)
  final List<Message> _pendingOutbox = [];

  ChatsRepositoryImpl(this._apiClient, this._logger);

  @override
  Stream<Message> get incomingMessagesStream =>
      _incomingMessagesController.stream;

  void handleIncomingMessage(Message message) {
    _incomingMessagesController.add(message);
  }

  @override
  Future<List<Conversation>> getConversations() async {
    try {
      final dtos = await _apiClient.getConversations();
      return saveConversationsFromRemote(dtos);
    } catch (e, st) {
      _logger.e(
        'Błąd podczas pobierania konwersacji',
        error: e,
        stackTrace: st,
        module: 'ChatsRepository',
      );
      rethrow;
    }
  }

  @override
  Future<List<Message>> getMessageHistory(
    String conversationId, {
    String? beforeId,
    int limit = 50,
  }) async {
    try {
      final dtos = await _apiClient.getMessageHistory(
        conversationId,
        beforeId: beforeId,
        limit: limit,
      );
      return dtos.map((dto) => mapMessageFromDto(dto, _currentUserId)).toList();
    } catch (e, st) {
      _logger.e(
        'Błąd podczas pobierania historii wiadomości',
        error: e,
        stackTrace: st,
        module: 'ChatsRepository',
      );
      rethrow;
    }
  }

  @override
  Future<void> sendMessage({
    required String conversationId,
    required String content,
  }) async {
    final payload = [
      {
        'conversation_id': conversationId,
        'content': content,
        'created_at': DateTime.now().toIso8601String(),
      },
    ];

    await _apiClient.sendOutboxBatch(payload);
  }

  @override
  Future<List<Message>> getPendingOutboxMessages() async {
    return List.unmodifiable(_pendingOutbox);
  }

  @override
  Future<void> clearSentOutboxMessages(List<String> messageIds) async {
    _pendingOutbox.removeWhere((msg) => messageIds.contains(msg.id));
    _logger.i(
      'Usunięto ${messageIds.length} wysłanych wiadomości z outboxa',
      module: 'ChatsRepository',
    );
  }

  @override
  Future<List<Conversation>> saveConversationsFromRemote(
    List<ConversationDto> dtos,
  ) async {
    final conversations = dtos
        .map((dto) => mapConversationFromDto(dto, _currentUserId))
        .toList();

    _logger.i(
      'Zaktualizowano ${conversations.length} konwersacji',
      module: 'ChatsRepository',
    );
    return conversations;
  }
}

@riverpod
ChatsRepository chatsRepository(Ref ref) {
  final apiClient = ref.watch(chatsApiClientProvider);
  final logger = ref.watch(appLoggerProvider);
  return ChatsRepositoryImpl(apiClient, logger);
}
