import 'dart:convert';

import 'package:obywatel_plus/features/communication/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/communication/data/dtos/message_dto.dart';
import 'package:obywatel_plus/features/communication/domain/chats/conversation.dart';
import 'package:obywatel_plus/features/communication/domain/chats/decrypted_message_content.dart';
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

DateTime normalizeTransportTimestamp(DateTime? value, {DateTime? fallback}) {
  final normalized = value?.toUtc() ?? fallback;
  return normalized ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
}

DateTime? parseTransportTimestamp(String? rawValue) {
  if (rawValue == null) {
    return null;
  }

  final trimmed = rawValue.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  final parsed = DateTime.tryParse(trimmed);
  if (parsed == null) {
    return null;
  }

  return parsed.toUtc();
}

DecryptedMessageContent? parseDecryptedMessageContent(String? rawContent) {
  final trimmed = rawContent?.trim() ?? '';
  if (trimmed.isEmpty) {
    return null;
  }

  try {
    final decoded = jsonDecode(trimmed);
    if (decoded is! Map) {
      return DecryptedMessageContent(text: trimmed);
    }

    final normalized = decoded.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    final attachment = normalized['attachment'];
    final text = normalized['text']?.toString() ?? '';

    if (attachment == null || attachment is! Map) {
      return DecryptedMessageContent(text: text);
    }

    final attachmentId = attachment['id']?.toString().trim();
    final attachmentKey = attachment['key']?.toString().trim();

    return DecryptedMessageContent(
      text: text,
      attachmentId:
          attachmentId != null && attachmentId.isNotEmpty ? attachmentId : null,
      attachmentKey:
          attachmentKey != null && attachmentKey.isNotEmpty ? attachmentKey : null,
      fileName: attachment['fileName']?.toString(),
      contentType: attachment['contentType']?.toString(),
      size: int.tryParse('${attachment['size']}'),
      sha256: attachment['sha256']?.toString(),
    );
  } catch (_) {
    return null;
  }
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

Message mapMessageFromDto(
  MessageDto dto,
  String currentUserId, {
  String? plaintext,
}) {
  final rawContent = plaintext ?? dto.encryptedPayload;
  final parsedContent = parseDecryptedMessageContent(rawContent);
  final resolvedAttachmentId =
      (dto.attachmentId ?? parsedContent?.attachmentId)?.trim();
  final resolvedPlaintext =
      (parsedContent?.text.isNotEmpty == true ? parsedContent!.text : rawContent)
          .trim();

  return Message(
    id: dto.id,
    conversationId: dto.conversationId,
    senderId: dto.senderId,
    content: resolvedPlaintext.isNotEmpty ? resolvedPlaintext : dto.encryptedPayload,
    encryptedPayload: dto.encryptedPayload,
    isMine: dto.senderId == currentUserId,
    createdAt: normalizeTransportTimestamp(dto.createdAt),
    status: 'sent',
    isEncrypted: true,
    attachmentId:
        resolvedAttachmentId != null && resolvedAttachmentId.isNotEmpty
            ? resolvedAttachmentId
            : null,
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
    updatedAt: dto.updatedAt == null
        ? null
        : normalizeTransportTimestamp(dto.updatedAt),
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

int? normalizeSignalType(String? rawType) {
  if (rawType == null || rawType.trim().isEmpty) {
    return null;
  }

  final parsed = int.tryParse(rawType.trim());
  if (parsed != null) {
    return parsed > 0 ? parsed : null;
  }

  final normalized = rawType.trim().toLowerCase();
  if (normalized.contains('pre')) return 3;
  if (normalized.contains('signal') || normalized.contains('cipher')) return 2;
  return null;
}

class LocalPlaintextMessageCache {
  final Map<String, String> _plaintextCache = <String, String>{};
  final Map<String, Set<String>> _plaintextIdAliases = <String, Set<String>>{};

  Map<String, String> get plaintextCache => _plaintextCache;
  Map<String, Set<String>> get plaintextAliases => _plaintextIdAliases;

  Set<String> collectRelatedMessageIds(String messageId) {
    final normalizedId = messageId.trim();
    if (normalizedId.isEmpty) {
      return <String>{};
    }

    final related = <String>{normalizedId};
    final queue = <String>[normalizedId];

    while (queue.isNotEmpty) {
      final current = queue.removeLast();
      final aliases = _plaintextIdAliases[current] ?? const <String>{};
      for (final alias in aliases) {
        final normalizedAlias = alias.trim();
        if (normalizedAlias.isNotEmpty && related.add(normalizedAlias)) {
          queue.add(normalizedAlias);
        }
      }
    }

    return related;
  }

  void registerAlias(String firstId, String secondId) {
    final left = firstId.trim();
    final right = secondId.trim();

    if (left.isEmpty || right.isEmpty || left == right) {
      return;
    }

    _plaintextIdAliases.putIfAbsent(left, () => <String>{}).add(right);
    _plaintextIdAliases.putIfAbsent(right, () => <String>{}).add(left);
  }

  String? resolve(String messageId) {
    final relatedIds = collectRelatedMessageIds(messageId);
    for (final candidate in relatedIds) {
      final value = _plaintextCache[candidate];
      if (value != null && value.trim().isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  void store(String messageId, String plaintext) {
    final normalized = plaintext.trim();
    if (normalized.isEmpty) {
      return;
    }

    final relatedIds = collectRelatedMessageIds(messageId)..add(messageId);
    for (final relatedId in relatedIds) {
      _plaintextCache[relatedId] = normalized;
    }

    for (final relatedId in relatedIds) {
      for (final aliasId in relatedIds.where(
        (candidate) => candidate != relatedId,
      )) {
        registerAlias(relatedId, aliasId);
      }
    }
  }
}
