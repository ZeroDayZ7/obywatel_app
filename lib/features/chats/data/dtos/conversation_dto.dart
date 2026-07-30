// lib/features/chats/data/dtos/conversation_dto.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/features/chats/data/dtos/message_dto.dart';

part 'conversation_dto.freezed.dart';
part 'conversation_dto.g.dart';

@freezed
abstract class ConversationMemberDto with _$ConversationMemberDto {
  const factory ConversationMemberDto({
    @JsonKey(name: 'ID') required String id,
    @JsonKey(name: 'ConversationID') required String conversationId,
    @JsonKey(name: 'UserID') required String userId,
    @JsonKey(name: 'Role') required String role,
    @JsonKey(name: 'LastReadSequence') @Default(0) int lastReadSequence,
  }) = _ConversationMemberDto;

  factory ConversationMemberDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationMemberDtoFromJson(json);
}

@freezed
abstract class ConversationDto with _$ConversationDto {
  const factory ConversationDto({
    @JsonKey(name: 'ID') required String id,
    @JsonKey(name: 'Type') required String type,
    @JsonKey(name: 'Title') String? title,
    @JsonKey(name: 'LastSequence') @Default(0) int lastSequence,
    @JsonKey(name: 'Members') @Default([]) List<ConversationMemberDto> members,
    @JsonKey(name: 'Messages') List<MessageDto?>? messages,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ConversationDto;

  factory ConversationDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationDtoFromJson(json);
}
