import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/auth/presentation/providers/auth_providers.dart';
import 'package:obywatel_plus/features/communication/application/e2ee_crypto_service.dart';
import 'package:obywatel_plus/features/communication/application/outbox_event_builder.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/communication/data/dtos/message_dto.dart';
import 'package:obywatel_plus/features/communication/domain/chats/conversation.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:obywatel_plus/features/communication/domain/repositories/chats_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'chats_repository_impl.g.dart';

String buildDirectConversationId(String userIdA, String userIdB) {
  final values = [
    userIdA.trim(),
    userIdB.trim(),
  ].where((value) => value.isNotEmpty).toList();

  if (values.length != 2) {
    throw ArgumentError.value(
      '$userIdA:$userIdB',
      'userIds',
      'Direct conversation requires exactly two user ids',
    );
  }

  final sorted = [...values]..sort();
  return sorted.join(':');
}

String resolveRemoteUserIdForConversation(
  String conversationId,
  String currentUserId,
) {
  final trimmedConversationId = conversationId.trim();
  if (trimmedConversationId.isEmpty) {
    throw ArgumentError.value(
      conversationId,
      'conversationId',
      'Conversation ID cannot be empty',
    );
  }

  final members = trimmedConversationId
      .split(':')
      .map((member) => member.trim())
      .where((member) => member.isNotEmpty)
      .toList();

  if (members.length == 1) {
    final remoteUserId = members.first;
    if (remoteUserId == currentUserId) {
      throw ArgumentError.value(
        conversationId,
        'conversationId',
        'Conversation does not contain a different peer user id',
      );
    }
    return remoteUserId;
  }

  if (members.length != 2) {
    throw ArgumentError.value(
      conversationId,
      'conversationId',
      'Conversation must contain exactly two members for direct peer messaging',
    );
  }

  if (!members.contains(currentUserId)) {
    throw ArgumentError.value(
      conversationId,
      'conversationId',
      'Current user is not part of this conversation',
    );
  }

  final remoteUserId = members.firstWhere(
    (member) => member != currentUserId,
    orElse: () => '',
  );

  if (remoteUserId.isEmpty || remoteUserId == currentUserId) {
    throw ArgumentError.value(
      conversationId,
      'conversationId',
      'Conversation does not contain a different peer user id',
    );
  }

  return remoteUserId;
}

Message mapMessageFromDto(MessageDto dto, String currentUserId) {
  return Message(
    id: dto.id,
    conversationId: dto.conversationId,
    senderId: dto.senderId,
    content: dto.encryptedPayload,
    encryptedPayload: dto.encryptedPayload,
    isMine: dto.senderId == currentUserId,
    createdAt: dto.createdAt,
    status: 'sent',
    isEncrypted: true,
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

List<MessageDto> parseRemoteMessageDtos(dynamic rawMessages) {
  final messageList = rawMessages as List<dynamic>? ?? const [];
  return messageList
      .map((item) => MessageDto.fromJson(item as Map<String, dynamic>))
      .toList();
}

int resolveLastKnownMessageVersion(
  Iterable<MessageDto> remoteMessages,
  int fallbackVersion,
) {
  var maxVersion = fallbackVersion;

  for (final dto in remoteMessages) {
    if (dto.version > maxVersion) {
      maxVersion = dto.version;
    }
  }

  return maxVersion;
}

int resolveLastKnownContactVersion(
  dynamic updatedContacts,
  int fallbackVersion,
) {
  final contactList = updatedContacts as List<dynamic>? ?? const [];
  var maxVersion = fallbackVersion;

  for (final item in contactList) {
    final contactMap = item as Map<String, dynamic>?;
    final version =
        int.tryParse(
          (contactMap?['version'] ?? contactMap?['Version'] ?? 0).toString(),
        ) ??
        0;
    if (version > maxVersion) {
      maxVersion = version;
    }
  }

  return maxVersion;
}

int normalizeSignalType(String? rawType, {int fallback = 1}) {
  if (rawType == null || rawType.trim().isEmpty) {
    return fallback;
  }

  final parsed = int.tryParse(rawType.trim());
  if (parsed != null) {
    return parsed;
  }

  final normalized = rawType.trim().toLowerCase();
  if (normalized.contains('pre')) return 3;
  if (normalized.contains('signal') || normalized.contains('cipher')) return 2;
  return fallback;
}

class ChatsRepositoryImpl implements ChatsRepository {
  final ChatsApiClient _apiClient;
  final AppDatabase _db;
  final StreamController<Message> _incomingMessagesController =
      StreamController.broadcast();
  final AppLogger _logger;
  final String _currentUserId;
  final DeviceInfoService _deviceInfoService;
  final E2eeCryptoService _cryptoService;
  final Map<String, String> _localPlaintextCache = <String, String>{};

  AppDatabase get db => _db;

  ChatsRepositoryImpl(
    this._apiClient,
    this._db,
    this._logger,
    String currentUserId,
    this._deviceInfoService,
    this._cryptoService,
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

  Future<String?> _findExistingConversationIdForPeer(String peerUserId) async {
    final normalizedPeerId = peerUserId.trim();
    if (normalizedPeerId.isEmpty || normalizedPeerId == _currentUserId) {
      return null;
    }

    final rows =
        await (_db.select(_db.conversationMembers)..where(
              (t) =>
                  t.userId.equals(_currentUserId) |
                  t.userId.equals(normalizedPeerId),
            ))
            .get();

    final byConversation = <String, Set<String>>{};
    for (final row in rows) {
      final conversationId = row.conversationId.trim();
      if (!Uuid.isValidUUID(fromString: conversationId)) {
        continue;
      }

      byConversation
          .putIfAbsent(conversationId, () => <String>{})
          .add(row.userId);
    }

    final exactMatches = <String>[];
    for (final entry in byConversation.entries) {
      final members = entry.value;
      final hasCurrentUser = members.contains(_currentUserId);
      final hasPeerUser = members.contains(normalizedPeerId);
      final isDirectOneToOne = members.length == 2;

      if (hasCurrentUser && hasPeerUser && isDirectOneToOne) {
        exactMatches.add(entry.key);
      }
    }

    if (exactMatches.length > 1) {
      throw StateError(
        'Multiple direct conversations found for currentUserId=$_currentUserId and peerUserId=$normalizedPeerId: ${exactMatches.join(', ')}',
      );
    }

    return exactMatches.isEmpty ? null : exactMatches.single;
  }

  @override
  Future<String> resolvePeerUserIdForConversation(String conversationId) async {
    final trimmedConversationId = conversationId.trim();
    if (trimmedConversationId.isEmpty) {
      throw ArgumentError.value(
        conversationId,
        'conversationId',
        'Conversation ID cannot be empty',
      );
    }

    if (Uuid.isValidUUID(fromString: trimmedConversationId)) {
      final members = await (_db.select(
        _db.conversationMembers,
      )..where((t) => t.conversationId.equals(trimmedConversationId))).get();

      final peerUserIds = members
          .map((member) => member.userId)
          .where((userId) => userId != _currentUserId)
          .toSet();

      if (peerUserIds.length == 1) {
        final peerUserId = peerUserIds.single;
        if (members.length == 2) {
          return peerUserId;
        }
      }

      throw ArgumentError.value(
        conversationId,
        'conversationId',
        'Conversation must be a direct 1:1 chat with exactly one peer user',
      );
    }

    if (!trimmedConversationId.contains(':')) {
      if (trimmedConversationId == _currentUserId) {
        throw ArgumentError.value(
          conversationId,
          'conversationId',
          'Conversation does not contain a different peer user id',
        );
      }
      return trimmedConversationId;
    }

    return resolveRemoteUserIdForConversation(
      trimmedConversationId,
      _currentUserId,
    );
  }

  @override
  Stream<List<Message>> watchMessagesForConversation(String conversationId) {
    final requestedConversationId = conversationId.trim();

    return _db.chatsDao
        .watchMessagesForConversation(requestedConversationId)
        .asyncMap((entities) async {
          final localMessages = entities.map(_messageFromEntity).toList();
          if (localMessages.isNotEmpty) {
            return localMessages;
          }

          final remoteUserId = await resolvePeerUserIdForConversation(
            requestedConversationId,
          );
          final resolvedConversationId =
              await _findExistingConversationIdForPeer(remoteUserId);

          if (resolvedConversationId == null) {
            return const <Message>[];
          }

          final relatedMessages = await _db.chatsDao.getMessagesForConversation(
            resolvedConversationId,
          );
          return relatedMessages.map(_messageFromEntity).toList();
        });
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
      throw ArgumentError.value(
        contactUserId,
        'contactUserId',
        'Nie może być puste',
      );
    }

    final normalizedPeerId = resolveRemoteUserIdForConversation(
      contactUserId,
      _currentUserId,
    );
    final existingConversationId = await _findExistingConversationIdForPeer(
      normalizedPeerId,
    );
    if (existingConversationId != null) {
      return existingConversationId;
    }

    final createdConversation = await _apiClient.createConversation(
      type: 'direct',
      recipientIds: [normalizedPeerId],
      title: title ?? 'Kontakt',
    );

    final serverConversationId = createdConversation.id.trim();
    if (!Uuid.isValidUUID(fromString: serverConversationId)) {
      throw StateError(
        'Backend returned invalid conversation UUID for contact $normalizedPeerId: $serverConversationId',
      );
    }

    await saveConversationsFromRemote([createdConversation]);
    return serverConversationId;
  }

  @override
  Future<void> ensureE2eeSessionForContact(String contactUserId) async {
    _logger.i(
      '[CHAT-FLOW-1] ensureE2eeSessionForContact start contactUserId=$contactUserId',
      module: 'ChatsRepository',
    );
    if (contactUserId.trim().isEmpty) {
      return;
    }

    try {
      _logger.i(
        '[CHAT-FLOW-1.1] registering device identity before peer session bootstrap',
        module: 'ChatsRepository',
      );
      await _cryptoService.registerDeviceIdentity();
      _logger.i(
        '[CHAT-FLOW-1.2] creating/confirming Signal session for peer $contactUserId',
        module: 'ChatsRepository',
      );
      await _cryptoService.ensureSessionForPeer(contactUserId);
      _logger.i(
        '[CHAT-FLOW-1.3] E2EE session ready for contact $contactUserId',
        module: 'ChatsRepository',
      );
    } catch (error, stackTrace) {
      _logger.w(
        'Nie udało się zainicjalizować sesji E2EE dla kontaktu $contactUserId',
        error: error,
        stackTrace: stackTrace,
        module: 'ChatsRepository',
      );
      rethrow;
    }
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
    _logger.i(
      '[CHAT-FLOW-2] getMessageHistory start conversationId=$conversationId limit=$limit',
      module: 'ChatsRepository',
    );
    try {
      final local = await _db.chatsDao.getMessagesForConversation(
        conversationId,
        limit: limit,
      );
      if (local.isNotEmpty) {
        _logger.i(
          '[CHAT-FLOW-2.1] local history returned for conversationId=$conversationId count=${local.length}',
          module: 'ChatsRepository',
        );
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
        _logger.i(
          '[CHAT-FLOW-2.2] storing remote history snapshot conversationId=$conversationId count=${newMessages.length}',
          module: 'ChatsRepository',
        );
        await _db.chatsDao.upsertMessages(newMessages);
      }

      _logger.i(
        '[CHAT-FLOW-2.3] history loaded from backend conversationId=$conversationId count=${dtos.length}',
        module: 'ChatsRepository',
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
    final operationId = const Uuid().v4();
    final createdAt = DateTime.now();
    final senderDeviceId = await _deviceInfoService.getOrCreateDeviceId();
    _logger.i(
      '[E2EE_TRACE] operation_id=$operationId stage=message_send_start event=start conversation_id=$conversationId local_user_id=$_currentUserId app_device_id=$senderDeviceId content_length=${content.length}',
      module: 'ChatsRepository',
    );

    if (content.trim().isEmpty) {
      throw const FormatException('Ciphertext wiadomości nie może być pusty');
    }

    final normalizedConversationId = conversationId.trim();
    final bool isExistingServerConversation = Uuid.isValidUUID(
      fromString: normalizedConversationId,
    );

    final remoteUserId = await resolvePeerUserIdForConversation(
      normalizedConversationId,
    );

    String? existingServerConversationId;
    if (!isExistingServerConversation) {
      existingServerConversationId = await _findExistingConversationIdForPeer(
        remoteUserId,
      );
    }

    final bool shouldPersistLocallyOnly =
        !isExistingServerConversation && existingServerConversationId == null;

    final String effectiveConversationId = isExistingServerConversation
        ? normalizedConversationId
        : (existingServerConversationId ?? normalizedConversationId);

    if (!isExistingServerConversation && existingServerConversationId != null) {
      _logger.i(
        '[SERVER_CONVERSATION_RESOLVED] localConversationId=$conversationId remoteUserId=$remoteUserId using=$effectiveConversationId',
        module: 'ChatsRepository',
      );
    }

    _logger.i(
      '[E2EE_ENCRYPT_START] operation_id=$operationId conversation_id=$effectiveConversationId remote_user_id=$remoteUserId',
      module: 'ChatsRepository',
    );

    late final EncryptedData encrypted;
    try {
      encrypted = await _cryptoService.encryptMessage(
        remoteUserId,
        content,
        operationId: operationId,
      );
      _logger.i(
        '[E2EE_TRACE] operation_id=$operationId stage=message_encrypt_success event=success conversation_id=$effectiveConversationId remote_user_id=$remoteUserId ciphertext_length=${encrypted.ciphertextBase64.length} signal_type=${encrypted.type}',
        module: 'ChatsRepository',
      );
    } catch (error, stackTrace) {
      _logger.e(
        '[E2EE_TRACE] operation_id=$operationId stage=message_encrypt_error event=error conversation_id=$effectiveConversationId remote_user_id=$remoteUserId error_type=${error.runtimeType} error_message=${error.toString()}',
        error: error,
        stackTrace: stackTrace,
        module: 'ChatsRepository',
      );
      rethrow;
    }

    final message = Message(
      id: const Uuid().v4(),
      conversationId: effectiveConversationId,
      senderId: _currentUserId,
      content: content,
      encryptedPayload: encrypted.ciphertextBase64,
      isMine: true,
      createdAt: createdAt,
      status: 'pending',
      isEncrypted: true,
    );
    final isServerBackedConversation = Uuid.isValidUUID(
      fromString: effectiveConversationId,
    );
    final outboxEventId = buildOutboxEventIdForMessage(message: message);
    _localPlaintextCache[message.id] = content;

    await _db.chatsDao.upsertMessages([
      _messageToCompanion(
        message,
        senderDeviceId: senderDeviceId,
        encryptedContent: encrypted.ciphertextBase64,
        signalType: encrypted.type,
      ),
    ]);

    if (shouldPersistLocallyOnly || !isServerBackedConversation) {
      _logger.i(
        '[LOCAL_MESSAGE_STORED_ONLY] message_id=${message.id} conversation_id=$effectiveConversationId status=pending',
        module: 'ChatsRepository',
      );
      final localOnlyMessage = message.copyWith(status: 'pending');
      _incomingMessagesController.add(localOnlyMessage);
      return;
    }

    final outboxEventPayload = buildOutboxEventPayload(
      message,
      senderDeviceId,
      encryptedContent: encrypted.ciphertextBase64,
      outboxEventId: outboxEventId,
      signalType: encrypted.type,
    );

    await _db.outboxDao.enqueueEvent(
      OutboxEventsCompanion(
        id: Value(message.id),
        outboxEventId: Value(outboxEventId),
        eventType: const Value('SEND_MESSAGE'),
        conversationId: Value(effectiveConversationId),
        payload: Value(jsonEncode(outboxEventPayload)),
        status: const Value('pending'),
        retryCount: const Value(0),
        attemptCount: const Value(0),
        nextAttemptAt: const Value.absent(),
        createdAt: Value(createdAt),
        updatedAt: Value(createdAt),
      ),
    );

    final requestPayload = {
      'conversation_id': effectiveConversationId,
      'sender_device_id': senderDeviceId,
      'ciphertext': encrypted.ciphertextBase64,
      'type': encrypted.type,
      'idempotency_key': message.id,
    };
    final requestUri = ApiEndpoints.conversationMessages(
      effectiveConversationId,
    );
    _logger.i(
      '[E2EE_TRACE] operation_id=$operationId stage=transport_send_request event=start conversation_id=$effectiveConversationId remote_user_id=$remoteUserId sender_app_device_id=$senderDeviceId uri=$requestUri ciphertext_length=${encrypted.ciphertextBase64.length} signal_type=${encrypted.type}',
      module: 'ChatsRepository',
    );

    Response<dynamic> response;
    try {
      response = await _apiClient.post(requestUri, data: requestPayload);
    } catch (error, stackTrace) {
      _logger.w(
        '[HTTP_POST_MESSAGE_ERROR] uri=$requestUri conversation_id=$effectiveConversationId keeping_message_pending',
        error: error,
        stackTrace: stackTrace,
        module: 'ChatsRepository',
      );
      return;
    }

    _logger.i(
      '[E2EE_TRACE] operation_id=$operationId stage=transport_send_response event=success conversation_id=$effectiveConversationId remote_user_id=$remoteUserId uri=$requestUri status_code=${response.statusCode}',
      module: 'ChatsRepository',
    );

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      _logger.w(
        '[HTTP_POST_MESSAGE_REJECTED] uri=$requestUri conversation_id=$effectiveConversationId status_code=${response.statusCode} keeping_message_pending',
        module: 'ChatsRepository',
      );
      return;
    }

    await (_db.update(
      _db.messages,
    )..where((tbl) => tbl.id.equals(message.id))).write(
      MessagesCompanion(
        status: const Value('sent'),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await _db.outboxDao.deleteEvents([message.id]);
    _logger.i(
      '[MESSAGE_DB_STATUS_UPDATED] message_id=${message.id} conversation_id=$effectiveConversationId status=sent',
      module: 'ChatsRepository',
    );

    final sentMessage = message.copyWith(status: 'sent');
    _logger.i(
      '[E2EE_TRACE] operation_id=$operationId stage=message_persist_success event=success conversation_id=$effectiveConversationId message_id=${message.id} status=sent',
      module: 'ChatsRepository',
    );
    _incomingMessagesController.add(sentMessage);
  }

  @override
  Future<List<Message>> getPendingOutboxMessages() async {
    final events = await _db.outboxDao.getRetryEligibleEvents();
    return events.map((event) {
      final payload = jsonDecode(event.payload) as Map<String, dynamic>? ?? {};
      final nestedPayload = payload['payload'] is Map<String, dynamic>
          ? payload['payload'] as Map<String, dynamic>
          : const <String, dynamic>{};
      final directEnvelope =
          payload['ciphertext'] != null || payload['conversation_id'] != null
          ? payload
          : nestedPayload;

      final createdAtValue =
          (directEnvelope['created_at'] as String?) ??
          (payload['created_at'] as String?) ??
          (nestedPayload['created_at'] as String?);
      final conversationId =
          (directEnvelope['conversation_id'] as String?) ??
          (payload['conversation_id'] as String?) ??
          (event.conversationId ?? '');
      final messageId =
          (directEnvelope['message_id'] as String?) ??
          (payload['event_id'] as String?) ??
          event.id;
      final ciphertext =
          (directEnvelope['ciphertext'] as String?) ??
          (nestedPayload['ciphertext'] as String?) ??
          '';

      return Message(
        id: messageId,
        conversationId: conversationId,
        senderId: (directEnvelope['sender_id'] as String?) ?? _currentUserId,
        content: ciphertext,
        isMine: true,
        createdAt: DateTime.tryParse(createdAtValue ?? '') ?? DateTime.now(),
        status: 'pending',
        isEncrypted: true,
        encryptedPayload: ciphertext,
      );
    }).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> syncDeltaFromRemote({
    int lastKnownContactVersion = 0,
    int lastKnownMessageVersion = 0,
  }) async {
    try {
      final checkpoint = await _db.syncStateDao.getForUser(_currentUserId);
      final resolvedLastKnownContactVersion = lastKnownContactVersion == 0
          ? (checkpoint?.lastKnownContactVersion ?? BigInt.zero).toInt()
          : lastKnownContactVersion;
      final resolvedLastKnownMessageVersion = lastKnownMessageVersion == 0
          ? (checkpoint?.lastKnownMessageVersion ?? BigInt.zero).toInt()
          : lastKnownMessageVersion;

      final payload = await _apiClient.syncDelta(
        lastKnownContactVersion: resolvedLastKnownContactVersion,
        lastKnownMessageVersion: resolvedLastKnownMessageVersion,
      );

      final updatedContacts =
          payload['updated_contacts'] as List<dynamic>? ?? const [];
      final newMessages = payload['new_messages'] as List<dynamic>? ?? const [];
      final remoteMessageDtos = parseRemoteMessageDtos(newMessages);

      if (remoteMessageDtos.isNotEmpty) {
        for (final dto in remoteMessageDtos) {
          if (dto.senderId == _currentUserId) {
            continue;
          }

          final decrypted = await _decryptInboundMessage(dto);
          if (decrypted != null) {
            _localPlaintextCache[dto.id] = decrypted;
            _logger.i(
              '[CHAT-FLOW-4.1] inbound delta message decrypted conversation_id=${dto.conversationId} message_id=${dto.id}',
              module: 'ChatsRepository',
            );
          } else {
            _logger.w(
              'Nie udało się odszyfrować wiadomości z delta sync; zachowuję ciphertext. '
              'conversation_id=${dto.conversationId} sender_id=${dto.senderId} message_id=${dto.id}',
              module: 'ChatsRepository',
            );
          }
        }

        await _db.chatsDao.upsertMessages(
          remoteMessageDtos.map(_messageDtoToCompanion).toList(),
        );
      }

      final nextMessageVersion = resolveLastKnownMessageVersion(
        remoteMessageDtos,
        resolvedLastKnownMessageVersion,
      );
      final nextContactVersion = resolveLastKnownContactVersion(
        updatedContacts,
        resolvedLastKnownContactVersion,
      );

      await _db.syncStateDao.upsertCheckpoint(
        userId: _currentUserId,
        lastKnownMessageVersion: BigInt.from(nextMessageVersion),
        lastKnownContactVersion: BigInt.from(nextContactVersion),
      );

      _logger.i(
        '[CHAT-FLOW-4] syncDeltaFromRemote complete remote_messages=${remoteMessageDtos.length} updated_contacts=${updatedContacts.length}',
        module: 'ChatsRepository',
      );

      return [
        {
          'updated_contacts': updatedContacts.length,
          'new_messages': remoteMessageDtos.length,
        },
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

    await (_db.update(
      _db.messages,
    )..where((tbl) => tbl.id.isIn(messageIds))).write(
      MessagesCompanion(
        status: const Value('sent'),
        updatedAt: Value(DateTime.now()),
      ),
    );

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

  Future<String?> _decryptInboundMessage(MessageDto dto) async {
    final ciphertext = dto.encryptedPayload.trim();
    final senderDeviceId = dto.senderDeviceId?.trim();
    final signalType = normalizeSignalType(dto.type);

    if (ciphertext.isEmpty) {
      _logger.w(
        'Odrzucam wiadomość wejściową bez ciphertext: message_id=${dto.id} conversation_id=${dto.conversationId}',
        module: 'ChatsRepository',
      );
      return null;
    }

    if (senderDeviceId == null || senderDeviceId.isEmpty) {
      _logger.w(
        'Odrzucam wiadomość wejściową bez senderDeviceId: message_id=${dto.id} conversation_id=${dto.conversationId}',
        module: 'ChatsRepository',
      );
      return null;
    }

    if (signalType <= 0) {
      _logger.w(
        'Odrzucam wiadomość wejściową z niepoprawnym wiadomoType: message_id=${dto.id} type=${dto.type}',
        module: 'ChatsRepository',
      );
      return null;
    }

    try {
      return await _cryptoService.decryptInboundMessage(
        senderUserId: dto.senderId,
        senderDeviceId: senderDeviceId,
        ciphertextBase64: ciphertext,
        type: signalType,
      );
    } catch (error, stackTrace) {
      _logger.w(
        'Inbound decrypt rejected for message ${dto.id}; device_id=$senderDeviceId type=$signalType',
        error: error,
        stackTrace: stackTrace,
        module: 'ChatsRepository',
      );
      return null;
    }
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
      status: const Value('sent'),
      createdAt: Value(dto.createdAt),
      updatedAt: Value(dto.createdAt),
      deletedAt: const Value.absent(),
    );
  }

  MessagesCompanion _messageToCompanion(
    Message message, {
    String? senderDeviceId,
    String? encryptedContent,
    int? signalType,
  }) {
    final ciphertext = encryptedContent ?? message.content;
    return MessagesCompanion(
      id: Value(message.id),
      conversationId: Value(message.conversationId),
      senderId: Value(message.senderId),
      senderDeviceId: Value(senderDeviceId ?? 'unknown-device'),
      type: Value(signalType?.toString() ?? 'text'),
      sequence: const Value.absent(),
      encryptedPayload: Value(utf8.encode(ciphertext)),
      mediaHeader: const Value.absent(),
      version: Value(BigInt.one),
      status: Value(message.status),
      createdAt: Value(message.createdAt),
      updatedAt: Value(DateTime.now()),
      deletedAt: const Value.absent(),
    );
  }

  Message _messageFromEntity(MessageEntity entity) {
    final ciphertext = utf8.decode(
      entity.encryptedPayload,
      allowMalformed: true,
    );
    final status = entity.status.isEmpty ? 'pending' : entity.status;
    final localPlaintext = _localPlaintextCache[entity.id];
    final normalizedType = entity.type.trim().toLowerCase();
    final isPlainTextMessage =
        normalizedType == 'text' || normalizedType == 'plain';

    if (localPlaintext != null) {
      return Message(
        id: entity.id,
        conversationId: entity.conversationId,
        senderId: entity.senderId,
        content: localPlaintext,
        encryptedPayload: ciphertext,
        isMine: entity.senderId == _currentUserId,
        createdAt: entity.createdAt,
        status: status,
        isEncrypted: !isPlainTextMessage,
      );
    }

    if (isPlainTextMessage) {
      return Message(
        id: entity.id,
        conversationId: entity.conversationId,
        senderId: entity.senderId,
        content: ciphertext,
        encryptedPayload: ciphertext,
        isMine: entity.senderId == _currentUserId,
        createdAt: entity.createdAt,
        status: status,
        isEncrypted: false,
      );
    }

    const encryptedPlaceholder =
        'Wiadomość zaszyfrowana – oczekiwanie na klucz sesji';
    return Message(
      id: entity.id,
      conversationId: entity.conversationId,
      senderId: entity.senderId,
      content: encryptedPlaceholder,
      encryptedPayload: ciphertext,
      isMine: entity.senderId == _currentUserId,
      createdAt: entity.createdAt,
      status: status,
      isEncrypted: true,
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
  final cryptoService = ref.watch(e2eeCryptoServiceProvider);

  return ChatsRepositoryImpl(
    apiClient,
    db,
    logger,
    currentUserId,
    deviceInfoService,
    cryptoService,
  );
}
