import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/auth/presentation/providers/auth_providers.dart';
import 'package:obywatel_plus/features/chats/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/chats/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/chats/data/dtos/message_dto.dart';
import 'package:obywatel_plus/features/chats/domain/models/conversation.dart';
import 'package:obywatel_plus/features/chats/domain/models/message.dart';
import 'package:obywatel_plus/features/chats/domain/repositories/chats_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chats_repository_impl.g.dart';

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
  final AppDatabase _db;
  final StreamController<Message> _incomingMessagesController =
      StreamController.broadcast();
  final AppLogger _logger;
  final String _currentUserId;
  final DeviceInfoService _deviceInfoService;

  ChatsRepositoryImpl(
    this._apiClient,
    this._db,
    this._logger,
    String currentUserId,
    this._deviceInfoService,
  ) : _currentUserId = currentUserId;

  @override
  Stream<Message> get incomingMessagesStream =>
      _incomingMessagesController.stream;

  @override
  Stream<List<Conversation>> watchConversations() {
    return _db.chatsDao.watchActiveConversations().asyncMap((entities) async {
      final list = <Conversation>[];
      for (final entity in entities) {
        final messages = await _db.chatsDao.getMessagesForConversation(
          entity.id,
          limit: 20,
        );
        list.add(
          Conversation(
            id: entity.id,
            type: entity.type,
            title: entity.title,
            lastSequence: entity.lastSequence.toInt(),
            members: const [],
            messages: messages.map(_messageFromEntity).toList(),
            updatedAt: entity.updatedAt,
          ),
        );
      }
      return list;
    });
  }

  @override
  Stream<List<Message>> watchMessagesForConversation(String conversationId) {
    return _db.chatsDao.watchMessagesForConversation(conversationId).map(
      (entities) => entities.map(_messageFromEntity).toList(),
    );
  }

  void handleIncomingMessage(Message message) {
    _incomingMessagesController.add(message);
  }

  @override
  Future<String> ensureConversationForContact(
    String contactUserId, {
    String? title,
  }) async {
    if (contactUserId.trim().isEmpty) {
      throw ArgumentError.value(contactUserId, 'contactUserId', 'Nie może być puste');
    }

    final sortedIds = [
      _currentUserId,
      contactUserId,
    ]..sort();
    final conversationId = sortedIds.join(':');
    final currentTime = DateTime.now();

    await _db.chatsDao.upsertConversations([
      ConversationsCompanion(
        id: Value(conversationId),
        type: Value('direct'),
        title: Value(title ?? 'Kontakt'),
        lastSequence: Value(BigInt.zero),
        updatedAt: Value(currentTime),
        createdAt: Value(currentTime),
        deletedAt: const Value.absent(),
      ),
    ]);

    final memberIds = <String>{_currentUserId, contactUserId};
    await _db.chatsDao.upsertMembers(
      memberIds
          .map(
            (userId) => ConversationMembersCompanion(
              id: Value('$conversationId:$userId'),
              conversationId: Value(conversationId),
              userId: Value(userId),
              role: Value(userId == _currentUserId ? 'admin' : 'member'),
              lastReadSequence: Value(BigInt.zero),
              createdAt: Value(currentTime),
              updatedAt: Value(currentTime),
              deletedAt: const Value.absent(),
            ),
          )
          .toList(),
    );

    return conversationId;
  }

  @override
  Future<List<Conversation>> getConversations() async {
    try {
      final entities = await _db.chatsDao.watchActiveConversations().first;
      if (entities.isNotEmpty) {
        final convs = <Conversation>[];
        for (final entity in entities) {
          final messages = await _db.chatsDao.getMessagesForConversation(
            entity.id,
            limit: 20,
          );
          convs.add(
            Conversation(
              id: entity.id,
              type: entity.type,
              title: entity.title,
              lastSequence: entity.lastSequence.toInt(),
              members: const [],
              messages: messages.map(_messageFromEntity).toList(),
              updatedAt: entity.updatedAt,
            ),
          );
        }
        return convs;
      }

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
      final local = await _db.chatsDao.getMessagesForConversation(
        conversationId,
        limit: limit,
      );
      if (local.isNotEmpty) {
        return local.map(_messageFromEntity).toList();
      }

      final dtos = await _apiClient.getMessageHistory(
        conversationId,
        beforeId: beforeId,
        limit: limit,
      );

      final newMessages = dtos
          .map((dto) => _messageDtoToCompanion(dto))
          .toList();
      if (newMessages.isNotEmpty) {
        await _db.chatsDao.upsertMessages(newMessages);
      }

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
    final createdAt = DateTime.now();
    final senderDeviceId = await _deviceInfoService.getOrCreateDeviceId();
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: conversationId,
      senderId: _currentUserId,
      content: content,
      isMine: true,
      createdAt: createdAt,
    );

    await _db.chatsDao.upsertMessages([
      _messageToCompanion(message, senderDeviceId: senderDeviceId),
    ]);
    await _db.outboxDao.enqueueEvent(
      OutboxEventsCompanion(
        id: Value(message.id),
        eventType: const Value('SEND_MESSAGE'),
        conversationId: Value(conversationId),
        payload: Value(
          jsonEncode({
            'id': message.id,
            'conversation_id': conversationId,
            'content': content,
            'created_at': createdAt.toIso8601String(),
          }),
        ),
        status: const Value('pending'),
        retryCount: const Value(0),
        createdAt: Value(createdAt),
      ),
    );

    _incomingMessagesController.add(message);
  }

  @override
  Future<List<Message>> getPendingOutboxMessages() async {
    final events = await _db.outboxDao.getPendingEvents();
    return events.map((event) {
      final payload = jsonDecode(event.payload) as Map<String, dynamic>;
      final createdAtValue = payload['created_at'] as String?;
      return Message(
        id: event.id,
        conversationId: payload['conversation_id'] as String? ?? event.conversationId ?? '',
        senderId: payload['sender_id'] as String? ?? _currentUserId,
        content: payload['content']?.toString() ?? '',
        isMine: true,
        createdAt: DateTime.tryParse(createdAtValue ?? '') ?? DateTime.now(),
      );
    }).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> syncDeltaFromRemote({
    int lastKnownContactVersion = 0,
    int lastKnownMessageVersion = 0,
  }) async {
    try {
      final payload = await _apiClient.syncDelta(
        lastKnownContactVersion: lastKnownContactVersion,
        lastKnownMessageVersion: lastKnownMessageVersion,
      );

      final updatedContacts = payload['updated_contacts'] as List<dynamic>? ?? const [];
      final newMessages = payload['new_messages'] as List<dynamic>? ?? const [];
      final remoteMessageDtos = newMessages
          .map((json) => MessageDto.fromJson(json as Map<String, dynamic>))
          .toList();

      if (remoteMessageDtos.isNotEmpty) {
        await _db.chatsDao.upsertMessages(
          remoteMessageDtos.map(_messageDtoToCompanion).toList(),
        );
      }

      return [
        {'updated_contacts': updatedContacts.length, 'new_messages': remoteMessageDtos.length},
      ];
    } catch (e, st) {
      _logger.e(
        'Błąd podczas synchronizacji delta',
        error: e,
        stackTrace: st,
        module: 'ChatsRepository',
      );
      rethrow;
    }
  }

  @override
  Future<void> clearSentOutboxMessages(List<String> messageIds) async {
    if (messageIds.isEmpty) return;
    await _db.outboxDao.deleteEvents(messageIds);
    _logger.i(
      'Usunięto ${messageIds.length} wysłanych wiadomości z outboxa',
      module: 'ChatsRepository',
    );
  }

  @override
  Future<List<Conversation>> saveConversationsFromRemote(
    List<ConversationDto> dtos,
  ) async {
    final conversations = <Conversation>[];

    for (final dto in dtos) {
      final conv = mapConversationFromDto(dto, _currentUserId);
      await _db.chatsDao.upsertConversations([
        ConversationsCompanion(
          id: Value(dto.id),
          type: Value(dto.type),
          title: Value(dto.title),
          lastSequence: Value(BigInt.from(dto.lastSequence)),
          updatedAt: Value(dto.updatedAt ?? DateTime.now()),
          createdAt: Value(dto.createdAt ?? DateTime.now()),
          deletedAt: const Value.absent(),
        ),
      ]);

      if (dto.members.isNotEmpty) {
        await _db.chatsDao.upsertMembers(
          dto.members
              .map(
                (member) => ConversationMembersCompanion(
                  id: Value(member.id),
                  conversationId: Value(member.conversationId),
                  userId: Value(member.userId),
                  role: Value(member.role),
                  lastReadSequence: Value(BigInt.from(member.lastReadSequence)),
                  createdAt: Value(DateTime.now()),
                  updatedAt: Value(DateTime.now()),
                  deletedAt: const Value.absent(),
                ),
              )
              .toList(),
        );
      }

      final remoteMessages = dto.messages
          ?.whereType<MessageDto>()
          .map(_messageDtoToCompanion)
          .toList();
      if (remoteMessages != null && remoteMessages.isNotEmpty) {
        await _db.chatsDao.upsertMessages(remoteMessages);
      }

      conversations.add(conv);
    }

    _logger.i(
      'Zaktualizowano ${conversations.length} konwersacji',
      module: 'ChatsRepository',
    );
    return conversations;
  }

  MessagesCompanion _messageDtoToCompanion(MessageDto dto) {
    return MessagesCompanion(
      id: Value(dto.id),
      conversationId: Value(dto.conversationId),
      senderId: Value(dto.senderId),
      senderDeviceId: Value(dto.senderDeviceId ?? ''),
      type: Value(dto.type),
      sequence: Value(BigInt.from(dto.sequence)),
      encryptedPayload: Value(utf8.encode(dto.encryptedPayload)),
      mediaHeader: const Value.absent(),
      version: Value(BigInt.from(dto.version)),
      createdAt: Value(dto.createdAt),
      updatedAt: Value(dto.createdAt),
      deletedAt: const Value.absent(),
    );
  }

  MessagesCompanion _messageToCompanion(
    Message message, {
    String? senderDeviceId,
  }) {
    return MessagesCompanion(
      id: Value(message.id),
      conversationId: Value(message.conversationId),
      senderId: Value(message.senderId),
      senderDeviceId: Value(senderDeviceId ?? 'unknown-device'),
      type: const Value('text'),
      sequence: Value(BigInt.from(DateTime.now().millisecondsSinceEpoch)),
      encryptedPayload: Value(utf8.encode(message.content)),
      mediaHeader: const Value.absent(),
      version: Value(BigInt.one),
      createdAt: Value(message.createdAt),
      updatedAt: Value(DateTime.now()),
      deletedAt: const Value.absent(),
    );
  }

  Message _messageFromEntity(MessageEntity entity) {
    return Message(
      id: entity.id,
      conversationId: entity.conversationId,
      senderId: entity.senderId,
      content: utf8.decode(entity.encryptedPayload, allowMalformed: true),
      isMine: entity.senderId == _currentUserId,
      createdAt: entity.createdAt,
    );
  }
}

@riverpod
ChatsRepository chatsRepository(Ref ref) {
  final apiClient = ref.watch(chatsApiClientProvider);
  final db = ref.watch(appDatabaseProvider);
  final logger = ref.watch(appLoggerProvider);
  final currentUserId = ref.watch(currentUserIdProvider);
  final deviceInfoService = ref.watch(deviceInfoServiceProvider);

  return ChatsRepositoryImpl(apiClient, db, logger, currentUserId, deviceInfoService);
}
