import 'package:obywatel_plus/features/communication/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/communication/data/dtos/message_dto.dart';
import 'package:obywatel_plus/features/communication/domain/chats/conversation.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';

bool isMessageSendAllowed({
  required String content,
  required String? attachmentId,
}) {
  final hasText = content.trim().isNotEmpty;
  final hasAttachment = attachmentId != null && attachmentId.trim().isNotEmpty;
  return hasText || hasAttachment;
}

String buildDirectConversationId(String userIdA, String userIdB) {
  final values = [userIdA.trim(), userIdB.trim()]
      .where((value) => value.isNotEmpty)
      .toList();

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
    attachmentId: dto.attachmentId,
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
    final version = int.tryParse((contactMap?['version'] ?? 0).toString()) ?? 0;
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

