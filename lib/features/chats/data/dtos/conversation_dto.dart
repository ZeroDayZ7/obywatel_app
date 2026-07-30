import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/features/chats/data/dtos/message_dto.dart';

part 'conversation_dto.freezed.dart';
part 'conversation_dto.g.dart';

@freezed
abstract class ConversationDto with _$ConversationDto {
  const factory ConversationDto({
    required String id,
    @JsonKey(name: 'participant_ids') required List<String> participantIds,
    @JsonKey(name: 'last_message') MessageDto? lastMessage,
    @JsonKey(name: 'unread_count') @Default(0) int unreadCount,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ConversationDto;

  factory ConversationDto.fromJson(Map<String, dynamic> json) =>
      _$ConversationDtoFromJson(json);
}
