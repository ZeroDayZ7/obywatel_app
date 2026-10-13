// lib/features/communication/data/dtos/conversation_dto.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/features/communication/data/dtos/message_dto.dart';

part 'conversation_dto.freezed.dart';
part 'conversation_dto.g.dart';

@freezed
abstract class ConversationMemberDto with _$ConversationMemberDto {
  const factory ConversationMemberDto({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'conversationId') required String conversationId,
    @JsonKey(name: 'userId') required String userId,
    @JsonKey(name: 'role') required String role,
    @JsonKey(name: 'lastReadSequence') @Default(0) int lastReadSequence,
  }) = _ConversationMemberDto;

  factory ConversationMemberDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationMemberDtoFromJson(json);
}

@freezed
abstract class ConversationDto with _$ConversationDto {
  const factory ConversationDto({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'lastSequence') @Default(0) int lastSequence,
    @JsonKey(name: 'members') @Default([]) List<ConversationMemberDto> members,
    @JsonKey(name: 'messages') List<MessageDto?>? messages,
    @JsonKey(name: 'createdAt') DateTime? createdAt,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
  }) = _ConversationDto;

  factory ConversationDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationDtoFromJson(json);
}
