import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/auth/presentation/providers/auth_providers.dart';
import 'package:obywatel_plus/features/communication/application/e2ee_crypto_service.dart';
import 'package:obywatel_plus/features/communication/application/outbox_event_builder.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/communication/data/dtos/message_dto.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_utils.dart';
import 'package:obywatel_plus/features/communication/domain/chats/conversation.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:obywatel_plus/features/communication/domain/crypto/e2ee_models.dart';
import 'package:obywatel_plus/features/communication/domain/repositories/chats_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'chats_repository_impl.g.dart';

class ChatsRepositoryImpl implements ChatsRepository {
  final ChatsApiClient _apiClient;
  final AppDatabase _db;
  final StreamController<Message> _incomingMessagesController =
      StreamController.broadcast();
  final AppLogger _logger;
  final String _currentUserId;
  final DeviceInfoService _deviceInfoService;
  final E2eeCryptoService _cryptoService;
  final SecureStorageService _secureStorage;
  final LocalPlaintextMessageCache _plaintextStore =
      LocalPlaintextMessageCache();

  AppDatabase get db => _db;

  Set<String> _collectRelatedMessageIds(String messageId) =>
      _plaintextStore.collectRelatedMessageIds(messageId);

  void _registerPlaintextAlias(String firstId, String secondId) =>
      _plaintextStore.registerAlias(firstId, secondId);

  String? _resolvePlaintextByMessageId(String messageId) =>
      _plaintextStore.resolve(messageId);

  String? _extractServerMessageIdFromResponse(dynamic responseData) {
    dynamic value = responseData;
    if (value is Map<String, dynamic>) {
      final direct = value['messageId'];
      if (direct is String) {
        final trimmed = direct.trim();
        if (trimmed.isNotEmpty) return trimmed;
      }
      if (value.containsKey('data')) {
        return _extractServerMessageIdFromResponse(value['data']);
      }
      return null;
    }

    if (value is Map) {
      final converted = value.map(
        (key, nestedValue) => MapEntry(key.toString(), nestedValue),
      );
      final direct = converted['messageId'];
      if (direct is String) {
        final trimmed = direct.trim();
        if (trimmed.isNotEmpty) return trimmed;
      }
      if (converted.containsKey('data')) {
        return _extractServerMessageIdFromResponse(converted['data']);
      }
      return null;
    }

    return null;
  }

  static const int _signalPlaintextVersion = 1;

  Map<String, dynamic> _buildSignalPlaintext({
    required String text,
    String? attachmentId,
    String? attachmentKey,
    String? attachmentFileName,
    String? attachmentContentType,
    int? attachmentSize,
    String? attachmentSha256,
  }) {
    final normalizedAttachmentId = (attachmentId ?? '').trim();
    final normalizedAttachmentKey = (attachmentKey ?? '').trim();
    final payload = <String, dynamic>{
      'v': _signalPlaintextVersion,
      'text': text,
    };

    if (normalizedAttachmentId.isNotEmpty ||
        normalizedAttachmentKey.isNotEmpty) {
      if (normalizedAttachmentId.isEmpty || normalizedAttachmentKey.isEmpty) {
        throw const FormatException(
          'Attachment metadata is incomplete: both attachmentId and key are required inside the encrypted message',
        );
      }

      payload['attachment'] = {
        'id': normalizedAttachmentId,
        'key': normalizedAttachmentKey,
        'size': attachmentSize ?? 0,
        'sha256': attachmentSha256 ?? '',
        'contentType': attachmentContentType ?? '',
        'fileName': attachmentFileName ?? '',
      };
    }

    return payload;
  }

  Map<String, dynamic>? _decodeSignalPlaintext(String plaintext) {
    final trimmed = plaintext.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is! Map) {
        return null;
      }

      final normalized = decoded.map(
        (key, value) => MapEntry(key.toString(), value),
      );
      final hasEnvelopeMarker =
          normalized.containsKey('v') ||
          normalized.containsKey('text') ||
          normalized.containsKey('attachment');
      if (!hasEnvelopeMarker) {
        return null;
      }

      final attachment = normalized['attachment'];
      if (attachment != null && attachment is! Map) {
        return null;
      }

      return {
        'text': normalized['text']?.toString() ?? '',
        'attachment': attachment,
      };
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> _readAttachmentMetadataForMessage(
    String attachmentId,
  ) async {
    final normalized = attachmentId.trim();
    if (normalized.isEmpty) {
      return null;
    }

    final stored = await _secureStorage.read(
      key: '$normalized-attachment-meta',
    );
    if (stored == null || stored.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(stored);
      if (decoded is! Map) {
        return null;
      }
      return decoded.map((key, value) => MapEntry(key.toString(), value));
    } catch (error, stackTrace) {
      _logger.w(
        'Attachment metadata exists but is unreadable for $normalized',
        error: error,
        stackTrace: stackTrace,
        module: 'ChatsRepository',
      );
      return null;
    }
  }

  ChatsRepositoryImpl(
    this._apiClient,
    this._db,
    this._logger,
    String currentUserId,
    this._deviceInfoService,
    this._cryptoService,
    this._secureStorage,
  ) : _currentUserId = currentUserId;

  Future<void> _persistPlaintextForMessage(
    String messageId,
    String plaintext,
  ) async {
    final normalized = plaintext.trim();
    if (normalized.isEmpty) {
      return;
    }

    _logger.i(
      '[CHAT-FLOW-STORE] caching plaintext in memory only for message_id=$messageId content_length=${normalized.length}',
      module: 'ChatsRepository',
    );

    final relatedIds = _collectRelatedMessageIds(messageId)..add(messageId);
    for (final relatedId in relatedIds) {
      _plaintextStore.plaintextCache[relatedId] = normalized;
    }

    for (final relatedId in relatedIds) {
      for (final aliasId in relatedIds.where(
        (candidate) => candidate != relatedId,
      )) {
        _registerPlaintextAlias(relatedId, aliasId);
      }
    }
  }

  Future<String?> _resolvePlaintextForEntity(MessageEntity entity) async {
    final ciphertext = utf8.decode(
      entity.encryptedPayload,
      allowMalformed: true,
    );
    final normalizedCiphertext = ciphertext.trim();
    if (normalizedCiphertext.isEmpty) {
      return null;
    }

    final normalizedType = entity.type.trim().toLowerCase();
    final isPlainTextMessage =
        normalizedType == 'text' || normalizedType == 'plain';
    if (isPlainTextMessage) {
      return normalizedCiphertext;
    }

    if (entity.senderDeviceId.trim().isEmpty) {
      return null;
    }

    try {
      final decrypted = await _cryptoService.decryptInboundMessage(
        senderUserId: entity.senderId,
        senderDeviceId: entity.senderDeviceId,
        ciphertextBase64: normalizedCiphertext,
        type: normalizeSignalType(entity.type),
      );

      final parsed = _decodeSignalPlaintext(decrypted);
      if (parsed != null) {
        final text = parsed['text']?.toString() ?? '';
        if (text.trim().isNotEmpty) {
          return text.trim();
        }
      }

      return decrypted.trim().isNotEmpty ? decrypted.trim() : null;
    } catch (error, stackTrace) {
      _logger.w(
        'Unable to decrypt cached message entity ${entity.id} in memory. Keeping ciphertext fallback only.',
        error: error,
        stackTrace: stackTrace,
        module: 'ChatsRepository',
      );
      return null;
    }
  }

  Future<void> _hydratePlaintextCacheForIds(Iterable<String> messageIds) async {
    final ids = <String>{};
    for (final messageId in messageIds) {
      final normalizedId = messageId.trim();
      if (normalizedId.isEmpty) {
        continue;
      }
      ids.addAll(_collectRelatedMessageIds(normalizedId));
    }

    if (ids.isEmpty) {
      return;
    }

    final entities = await (_db.select(
      _db.messages,
    )..where((tbl) => tbl.id.isIn(ids.toList()))).get();

    for (final entity in entities) {
      if (_plaintextStore.resolve(entity.id) != null) {
        continue;
      }

      final plaintext = await _resolvePlaintextForEntity(entity);
      if (plaintext != null && plaintext.trim().isNotEmpty) {
        _plaintextStore.store(entity.id, plaintext);
      }
    }
  }

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
        await _hydratePlaintextCacheForIds(
          messages.map((message) => message.id),
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
  Future<String> ensureSelfConversation() async {
    final existingId = await _findExistingSelfConversationId();
    if (existingId != null) {
      return existingId;
    }

    final createdConversation = await _apiClient.createConversation(
      type: 'direct',
      recipientIds: [_currentUserId],
      title: 'Chat ze sobą',
    );

    final selfConversationId = createdConversation.id.trim();
    if (!Uuid.isValidUUID(fromString: selfConversationId)) {
      throw StateError(
        'Backend returned invalid self-conversation UUID: $selfConversationId',
      );
    }

    await saveConversationsFromRemote([createdConversation]);
    return selfConversationId;
  }

  Future<String?> _findExistingSelfConversationId() async {
    final rows = await (_db.select(
      _db.conversationMembers,
    )..where((t) => t.userId.equals(_currentUserId))).get();

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

    for (final entry in byConversation.entries) {
      final members = entry.value;
      if (members.length == 1 && members.contains(_currentUserId)) {
        return entry.key;
      }
    }

    return null;
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

      if (peerUserIds.isEmpty && members.length <= 1) {
        return _currentUserId;
      }

      if (peerUserIds.length == 1 && members.length == 2) {
        return peerUserIds.single;
      }

      throw ArgumentError.value(
        conversationId,
        'conversationId',
        'Conversation must be a direct 1:1 chat with exactly one peer user',
      );
    }

    if (!trimmedConversationId.contains(':')) {
      if (trimmedConversationId == _currentUserId) {
        return _currentUserId;
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
          await _hydratePlaintextCacheForIds(
            entities.map((entity) => entity.id),
          );
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
          await _hydratePlaintextCacheForIds(
            relatedMessages.map((message) => message.id),
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
      final local = _orderMessageEntities(
        await _db.chatsDao.getMessagesForConversation(
          conversationId,
          limit: limit,
        ),
      );
      if (local.isNotEmpty) {
        await _hydratePlaintextCacheForIds(local.map((message) => message.id));
        _logger.i(
          '[CHAT-FLOW-2.1] local history returned for conversationId=$conversationId count=${local.length}',
          module: 'ChatsRepository',
        );
        return local.map(_messageFromEntity).toList();
      }

      final dtos = _orderMessageDtos(
        await _apiClient.getMessageHistory(
          conversationId,
          beforeId: beforeId,
          limit: limit,
        ),
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
    String? attachmentId,
  }) async {
    final operationId = const Uuid().v4();
    final createdAt = DateTime.now().toUtc();
    final senderAppDeviceId = await _deviceInfoService.getOrCreateDeviceId();

    final normalizedConversationId = conversationId.trim();
    final remoteUserId = await resolvePeerUserIdForConversation(
      normalizedConversationId,
    );

    final hasTextContent = content.trim().isNotEmpty;
    final hasAttachment =
        attachmentId != null && attachmentId.trim().isNotEmpty;
    if (!hasTextContent && !hasAttachment) {
      throw const FormatException('Ciphertext wiadomości nie może być pusty');
    }

    final bool isExistingServerConversation = Uuid.isValidUUID(
      fromString: normalizedConversationId,
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
      _logger.w(
        '[SERVER_CONVERSATION_RESOLVED] localConversationId=$conversationId remoteUserId=$remoteUserId using=$effectiveConversationId',
        module: 'ChatsRepository',
      );
    }

    String signalPlaintext = content;
    String effectiveDisplayContent = content;

    if (hasAttachment) {
      final attachmentMetadata = await _readAttachmentMetadataForMessage(
        attachmentId,
      );
      final attachmentKey = attachmentMetadata?['key']?.toString().trim();
      if (attachmentKey == null || attachmentKey.isEmpty) {
        throw const FormatException(
          'Attachment metadata missing: no valid key can be embedded in the encrypted message for this attachment.',
        );
      }

      final fileName =
          attachmentMetadata?['originalFilename']?.toString() ??
          attachmentMetadata?['fileName']?.toString() ??
          '';

      signalPlaintext = jsonEncode(
        _buildSignalPlaintext(
          text: content,
          attachmentId: attachmentId,
          attachmentKey: attachmentKey,
          attachmentFileName: fileName,
          attachmentContentType:
              attachmentMetadata?['originalContentType']?.toString() ??
              attachmentMetadata?['contentType']?.toString() ??
              '',
          attachmentSize:
              int.tryParse((attachmentMetadata?['size'] ?? 0).toString()) ?? 0,
          attachmentSha256: attachmentMetadata?['sha256']?.toString() ?? '',
        ),
      );

      if (effectiveDisplayContent.trim().isEmpty) {
        effectiveDisplayContent = fileName.isNotEmpty
            ? '📎 $fileName'
            : '📎 Załącznik';
      }
    } else {
      signalPlaintext = jsonEncode(_buildSignalPlaintext(text: content));
    }

    late final EncryptedData encrypted;
    try {
      encrypted = await _cryptoService.encryptMessage(
        remoteUserId,
        signalPlaintext,
        operationId: operationId,
      );
    } catch (error, stackTrace) {
      _logger.e(
        '[E2EE_TRACE] operation_id=$operationId stage=message_encrypt_error event=error conversationId=$effectiveConversationId remote_user_id=$remoteUserId error_type=${error.runtimeType} error_message=${error.toString()}',
        error: error,
        stackTrace: stackTrace,
        module: 'ChatsRepository',
      );
      rethrow;
    }

    final message = Message(
      id: const Uuid().v7(),
      conversationId: effectiveConversationId,
      senderId: _currentUserId,
      content: effectiveDisplayContent,
      encryptedPayload: encrypted.ciphertextBase64,
      isMine: true,
      createdAt: createdAt,
      status: 'pending',
      isEncrypted: true,
      attachmentId: attachmentId,
    );
    final isServerBackedConversation = Uuid.isValidUUID(
      fromString: effectiveConversationId,
    );
    final hasValidServerConversation = effectiveConversationId
        .trim()
        .isNotEmpty;
    final hasCiphertextPayload = encrypted.ciphertextBase64.trim().isNotEmpty;
    if (!hasValidServerConversation || !hasCiphertextPayload) {
      _logger.w(
        '[OUTBOX-FLOW-4] refusing to enqueue invalid outbox event without clearing data: message_id=${message.id} conversationId=$effectiveConversationId ciphertext_present=$hasCiphertextPayload',
        module: 'ChatsRepository',
      );
      final localOnlyMessage = message.copyWith(status: 'pending');
      _incomingMessagesController.add(localOnlyMessage);
      return;
    }

    final outboxEventId = buildOutboxEventIdForMessage(message: message);
    await _persistPlaintextForMessage(message.id, effectiveDisplayContent);

    await _db.chatsDao.upsertMessages([
      _messageToCompanion(
        message,
        senderDeviceId: senderAppDeviceId,
        encryptedContent: encrypted.ciphertextBase64,
        signalType: encrypted.type,
      ),
    ]);

    if (shouldPersistLocallyOnly || !isServerBackedConversation) {
      final localOnlyMessage = message.copyWith(status: 'pending');
      _incomingMessagesController.add(localOnlyMessage);
      return;
    }

    final outboxEventPayload = buildOutboxEventPayload(
      message,
      senderAppDeviceId,
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
      'messageId': message.id,
      'conversationId': effectiveConversationId,
      'senderDeviceId': senderAppDeviceId,
      'attachmentId': attachmentId,
      'ciphertext': encrypted.ciphertextBase64,
      'type': encrypted.type,
      'idempotencyKey': message.id,
    };
    final requestUri = ApiEndpoints.conversationMessages(
      effectiveConversationId,
    );
    Response<dynamic> response;
    try {
      response = await _apiClient.post(requestUri, data: requestPayload);
    } catch (error, stackTrace) {
      _logger.w(
        '[HTTP_POST_MESSAGE_ERROR] uri=$requestUri conversationId=$effectiveConversationId keeping_message_pending',
        error: error,
        stackTrace: stackTrace,
        module: 'ChatsRepository',
      );
      return;
    }

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      _logger.w(
        '[HTTP_POST_MESSAGE_REJECTED] uri=$requestUri conversationId=$effectiveConversationId status_code=${response.statusCode} keeping_message_pending',
        module: 'ChatsRepository',
      );
      return;
    }

    final serverMessageId = _extractServerMessageIdFromResponse(response.data);
    if (serverMessageId != null &&
        serverMessageId.trim().isNotEmpty &&
        serverMessageId != message.id) {
      _registerPlaintextAlias(message.id, serverMessageId);
      await _persistPlaintextForMessage(serverMessageId, content);
    }

    await (_db.update(
      _db.messages,
    )..where((tbl) => tbl.id.equals(message.id))).write(
      MessagesCompanion(
        status: const Value('sent'),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
    await _db.outboxDao.deleteEvents([message.id]);

    final sentMessage = message.copyWith(status: 'sent');
    _incomingMessagesController.add(sentMessage);
  }

  String? _readOutboxString(dynamic value) {
    if (value == null) return null;
    final normalized = value.toString().trim();
    return normalized.isEmpty ? null : normalized;
  }

  Map<String, dynamic>? _decodeOutboxPayload(String rawPayload) {
    if (rawPayload.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(rawPayload);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
      return null;
    } catch (error, stackTrace) {
      _logger.w(
        '[OUTBOX-FLOW-INVALID-JSON] skipping malformed outbox payload. payload_prefix=${rawPayload.length > 128 ? rawPayload.substring(0, 128) : rawPayload}',
        error: error,
        stackTrace: stackTrace,
        module: 'ChatsRepository',
      );
      return null;
    }
  }

  @override
  Future<List<Message>> getPendingOutboxMessages() async {
    final events = await _db.outboxDao.getRetryEligibleEvents();

    final messages = <Message>[];
    for (final event in events) {
      final payload = _decodeOutboxPayload(event.payload);
      if (payload == null) {
        continue;
      }

      final nestedPayload = payload['payload'] is Map
          ? Map<String, dynamic>.from(payload['payload'] as Map)
          : const <String, dynamic>{};
      final directEnvelope =
          payload['ciphertext'] != null ||
              payload['conversationId'] != null ||
              payload['messageId'] != null
          ? payload
          : nestedPayload;

      final createdAtValue =
          _readOutboxString(directEnvelope['createdAt']) ??
          _readOutboxString(payload['createdAt']) ??
          _readOutboxString(nestedPayload['createdAt']);
      final conversationId =
          _readOutboxString(directEnvelope['conversationId']) ??
          _readOutboxString(payload['conversationId']) ??
          _readOutboxString(event.conversationId) ??
          '';
      final messageId =
          _readOutboxString(directEnvelope['messageId']) ??
          _readOutboxString(payload['messageId']) ??
          _readOutboxString(event.id) ??
          event.id;
      final ciphertext =
          _readOutboxString(directEnvelope['ciphertext']) ??
          _readOutboxString(nestedPayload['ciphertext']) ??
          '';
      final signalTypeString =
          _readOutboxString(directEnvelope['type']) ??
          _readOutboxString(payload['type']) ??
          _readOutboxString(directEnvelope['signalType']) ??
          _readOutboxString(payload['signalType']) ??
          '1';

      final normalizedSignalType = normalizeSignalType(signalTypeString);
      if (normalizedSignalType <= 0) {
        _logger.w(
          '[OUTBOX-FLOW-INVALID-SIGNAL-TYPE] skipping pending outbox entry with unsupported signal type. message_id=$messageId conversationId=$conversationId signal_type=$signalTypeString',
          module: 'ChatsRepository',
        );
        continue;
      }

      messages.add(
        Message(
          id: messageId,
          conversationId: conversationId,
          senderId:
              _readOutboxString(directEnvelope['sender_id']) ??
              _readOutboxString(directEnvelope['senderId']) ??
              _currentUserId,
          content: ciphertext,
          isMine: true,
          createdAt: normalizeTransportTimestamp(
            parseTransportTimestamp(createdAtValue),
          ),
          status: 'pending',
          isEncrypted: true,
          encryptedPayload: ciphertext,
        ),
      );
    }

    return messages;
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
          payload['updatedContacts'] as List<dynamic>? ?? const [];
      final newMessages = payload['newMessages'] as List<dynamic>? ?? const [];
      final remoteMessageDtos = _orderMessageDtos(
        parseRemoteMessageDtos(newMessages),
      );

      if (remoteMessageDtos.isNotEmpty) {
        for (final dto in remoteMessageDtos) {
          final decrypted = await _decryptInboundMessage(dto);
          if (decrypted != null) {
            await _persistPlaintextForMessage(dto.id, decrypted);
            _logger.i(
              '[CHAT-FLOW-4.1] inbound delta message decrypted conversationId=${dto.conversationId} message_id=${dto.id}',
              module: 'ChatsRepository',
            );
          } else {
            _logger.w(
              'Nie udało się odszyfrować wiadomości z delta sync; zachowuję ciphertext. '
              'conversationId=${dto.conversationId} sender_id=${dto.senderId} message_id=${dto.id}',
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
        '[CHAT-FLOW-4] syncDeltaFromRemote complete remoteMessages=${remoteMessageDtos.length} updatedContacts=${updatedContacts.length}',
        module: 'ChatsRepository',
      );

      return [
        {
          'updatedContacts': updatedContacts.length,
          'newMessages': remoteMessageDtos.length,
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

    await _db.transaction(() async {
      await (_db.update(
        _db.messages,
      )..where((tbl) => tbl.id.isIn(messageIds))).write(
        MessagesCompanion(
          status: const Value('sent'),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );

      await _db.outboxDao.deleteEvents(messageIds);
    });

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
          updatedAt: Value(normalizeTransportTimestamp(dto.updatedAt)),
          createdAt: Value(normalizeTransportTimestamp(dto.createdAt)),
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
                  createdAt: Value(DateTime.now().toUtc()),
                  updatedAt: Value(DateTime.now().toUtc()),
                  deletedAt: const Value.absent(),
                ),
              )
              .toList(),
        );
      }

      final remoteMessages = _orderMessageDtos(
        dto.messages?.whereType<MessageDto>() ?? const <MessageDto>[],
      ).map(_messageDtoToCompanion).toList();
      if (remoteMessages.isNotEmpty) {
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

  List<MessageEntity> _orderMessageEntities(Iterable<MessageEntity> entities) {
    final ordered = entities.toList()
      ..sort((left, right) {
        final leftHasSequence = left.sequence != null;
        final rightHasSequence = right.sequence != null;

        if (leftHasSequence && rightHasSequence) {
          final compare = left.sequence!.compareTo(right.sequence!);
          if (compare != 0) {
            return compare;
          }
        } else if (leftHasSequence != rightHasSequence) {
          return leftHasSequence ? -1 : 1;
        }

        final createdAtCompare = left.createdAt.compareTo(right.createdAt);
        if (createdAtCompare != 0) {
          return createdAtCompare;
        }

        return left.id.compareTo(right.id);
      });

    return ordered;
  }

  List<MessageDto> _orderMessageDtos(Iterable<MessageDto> dtos) {
    final ordered = dtos.toList()
      ..sort((left, right) {
        final sequenceCompare = left.sequence.compareTo(right.sequence);
        if (sequenceCompare != 0) {
          return sequenceCompare;
        }

        final createdAtCompare = left.createdAt.compareTo(right.createdAt);
        if (createdAtCompare != 0) {
          return createdAtCompare;
        }

        return left.id.compareTo(right.id);
      });

    return ordered;
  }

  Future<String?> _decryptInboundMessage(MessageDto dto) async {
    final ciphertext = dto.encryptedPayload.trim();
    final senderDeviceId = dto.senderDeviceId?.trim();
    final signalType = normalizeSignalType(dto.type);

    if (ciphertext.isEmpty ||
        senderDeviceId == null ||
        senderDeviceId.isEmpty ||
        signalType <= 0) {
      return null;
    }

    try {
      final decrypted = await _cryptoService.decryptInboundMessage(
        senderUserId: dto.senderId,
        senderDeviceId: senderDeviceId,
        ciphertextBase64: ciphertext,
        type: signalType,
      );

      final parsed = _decodeSignalPlaintext(decrypted);
      if (parsed != null) {
        var text = parsed['text']?.toString() ?? '';
        final attachment = parsed['attachment'];
        String? extractedAttachmentId;

        if (attachment is Map) {
          extractedAttachmentId = attachment['id']?.toString();
          final attachmentKey = attachment['key']?.toString();

          if (extractedAttachmentId != null &&
              extractedAttachmentId.trim().isNotEmpty &&
              attachmentKey != null &&
              attachmentKey.trim().isNotEmpty) {
            final keyRef = '$extractedAttachmentId-attachment-key';
            await _secureStorage.write(key: keyRef, value: attachmentKey);

            final attachmentMetadata = {
              'version': 1,
              'attachmentId': extractedAttachmentId,
              'key': attachmentKey,
              'keyRef': keyRef,
              'ciphertextAlgorithm': 'AES-256-GCM',
              'originalContentType': attachment['contentType'] ?? '',
              'originalFilename': attachment['fileName'] ?? '',
              'size': attachment['size'] ?? 0,
              'sha256': attachment['sha256'] ?? '',
            };

            await _secureStorage.write(
              key: '$extractedAttachmentId-attachment-meta',
              value: jsonEncode(attachmentMetadata),
            );

            // NAPRAWA 1: Jeśli wiadomość ma tylko załącznik (brak tekstu),
            // ustawiamy czytelny placeholder, aby przeszło przez cache plaintextu!
            if (text.isEmpty) {
              final fileName = attachment['fileName']?.toString();
              text = (fileName != null && fileName.trim().isNotEmpty)
                  ? '📎 $fileName'
                  : '📎 Załącznik';
            }
          }
        }

        // NAPRAWA 2: Zapisujemy plaintext (nawet wygenerowany dla załącznika)
        if (text.isNotEmpty) {
          await _persistPlaintextForMessage(dto.id, text);
        }

        // NAPRAWA 3: Aktualizujemy bazę Drift, aby przypisać attachmentId do wiadomości
        if (extractedAttachmentId != null &&
            extractedAttachmentId.trim().isNotEmpty) {
          await (_db.update(
            _db.messages,
          )..where((tbl) => tbl.id.equals(dto.id))).write(
            MessagesCompanion(
              attachmentId: Value(extractedAttachmentId),
              updatedAt: Value(DateTime.now().toUtc()),
            ),
          );
        }

        return text;
      }

      // Fallback dla wiadomości bez struktury JSON
      if (decrypted.trim().isNotEmpty) {
        await _persistPlaintextForMessage(dto.id, decrypted);
      }

      return decrypted;
    } catch (error, stackTrace) {
      _logger.w(
        'Inbound decrypt rejected for message ${dto.id}',
        error: error,
        stackTrace: stackTrace,
        module: 'ChatsRepository',
      );
      return null;
    }
  }

  MessagesCompanion _messageDtoToCompanion(MessageDto dto) {
    // 1. Sprawdzamy, czy DTO ma attachmentId. Jeśli nie, próbujemy je wyciągnąć z odszyfrowanego plaintextu lub metadanych.
    String? resolvedAttachmentId = dto.attachmentId;

    if ((resolvedAttachmentId == null || resolvedAttachmentId.trim().isEmpty) &&
        dto.encryptedPayload.isNotEmpty) {
      try {
        // Czasami w delta sync attachmentId jest wewnątrz zaszyfrowanego payloadu (json)
        // lub możemy spróbować odczytać z SecureStorage po kluczu wiadomości
        // Alternatywnie: jeśli mamy powiązany wpis w SecureStorage dla tej wiadomości:
      } catch (_) {}
    }

    return MessagesCompanion(
      id: Value(dto.id),
      conversationId: Value(dto.conversationId),
      senderId: Value(dto.senderId),
      senderDeviceId: Value(dto.senderDeviceId ?? ''),
      // NAPRAWA: Jeśli dto nie ma attachmentId, używamy zabezpieczonego ID lub nie nadpisujemy pustą wartością
      attachmentId:
          resolvedAttachmentId != null && resolvedAttachmentId.trim().isNotEmpty
          ? Value(resolvedAttachmentId)
          : const Value.absent(), // <--- const Value.absent() sprawi, że Drift nie nadpisze istniejącego ID wartością null!
      type: Value(dto.type),
      sequence: Value(BigInt.from(dto.sequence)),
      encryptedPayload: Value(utf8.encode(dto.encryptedPayload)),
      mediaHeader: const Value.absent(),
      version: Value(BigInt.from(dto.version)),
      status: const Value('sent'),
      createdAt: Value(normalizeTransportTimestamp(dto.createdAt)),
      updatedAt: Value(normalizeTransportTimestamp(dto.createdAt)),
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
      attachmentId: Value(message.attachmentId),
      type: Value(signalType?.toString() ?? 'text'),
      sequence: const Value.absent(),
      encryptedPayload: Value(utf8.encode(ciphertext)),
      mediaHeader: const Value.absent(),
      version: Value(BigInt.one),
      status: Value(message.status),
      createdAt: Value(normalizeTransportTimestamp(message.createdAt)),
      updatedAt: Value(DateTime.now().toUtc()),
      deletedAt: const Value.absent(),
    );
  }

  Message _messageFromEntity(MessageEntity entity) {
    final ciphertext = utf8.decode(
      entity.encryptedPayload,
      allowMalformed: true,
    );
    final status = entity.status.isEmpty ? 'pending' : entity.status;
    final localPlaintext = _resolvePlaintextByMessageId(entity.id);
    final normalizedType = entity.type.trim().toLowerCase();
    final isPlainTextMessage =
        normalizedType == 'text' || normalizedType == 'plain';
    final hasAttachment = (entity.attachmentId ?? '').trim().isNotEmpty;

    _logger.i(
      '[CHAT-FLOW-RENDER] Mapping message entity id=${entity.id} has_local_plaintext=${localPlaintext != null} attachmentId=${entity.attachmentId}',
      module: 'ChatsRepository',
    );

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
        attachmentId: entity.attachmentId,
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
        attachmentId: entity.attachmentId,
      );
    }

    final fallbackContent = hasAttachment
        ? '📎 Załącznik'
        : 'Nie można odszyfrować wiadomości';

    return Message(
      id: entity.id,
      conversationId: entity.conversationId,
      senderId: entity.senderId,
      content: fallbackContent,
      encryptedPayload: ciphertext,
      isMine: entity.senderId == _currentUserId,
      createdAt: entity.createdAt,
      status: status,
      isEncrypted: true,
      attachmentId: entity.attachmentId,
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
  final secureStorage = ref.watch(secureStorageProvider);

  return ChatsRepositoryImpl(
    apiClient,
    db,
    logger,
    currentUserId,
    deviceInfoService,
    cryptoService,
    secureStorage,
  );
}
