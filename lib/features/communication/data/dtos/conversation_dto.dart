// lib/features/communication/data/dtos/conversation_dto.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/features/communication/data/dtos/message_dto.dart';

part 'conversation_dto.freezed.dart';
part 'conversation_dto.g.dart';

Map<String, dynamic> _normalizeConversationJson(Map<String, dynamic> json) {
  final normalized = <String, dynamic>{};

  for (final entry in json.entries) {
    final rawKey = entry.key.trim();
    final key = switch (rawKey) {
      'ID' || 'id' => 'id',
      'ConversationID' ||
      'conversation_id' ||
      'conversationId' => 'conversation_id',
      'UserID' || 'user_id' || 'userId' => 'user_id',
      'Role' || 'role' => 'role',
      'LastReadSequence' ||
      'last_read_sequence' ||
      'lastReadSequence' => 'last_read_sequence',
      'Type' || 'type' => 'type',
      'Title' || 'title' => 'title',
      'LastSequence' || 'last_sequence' || 'lastSequence' => 'last_sequence',
      'Members' || 'members' => 'members',
      'Messages' || 'messages' => 'messages',
      'created_at' || 'createdAt' => 'created_at',
      'updated_at' || 'updatedAt' => 'updated_at',
      _ => rawKey,
    };

    normalized[key] = entry.value;
  }

  return normalized;
}

@freezed
abstract class ConversationMemberDto with _$ConversationMemberDto {
  const factory ConversationMemberDto({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'conversation_id') required String conversationId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'role') required String role,
    @JsonKey(name: 'last_read_sequence') @Default(0) int lastReadSequence,
  }) = _ConversationMemberDto;

  factory ConversationMemberDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationMemberDtoFromJson(_normalizeConversationJson(json));
}

@freezed
abstract class ConversationDto with _$ConversationDto {
  const factory ConversationDto({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'last_sequence') @Default(0) int lastSequence,
    @JsonKey(name: 'members') @Default([]) List<ConversationMemberDto> members,
    @JsonKey(name: 'messages') List<MessageDto?>? messages,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ConversationDto;

  factory ConversationDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationDtoFromJson(_normalizeConversationJson(json));
}
