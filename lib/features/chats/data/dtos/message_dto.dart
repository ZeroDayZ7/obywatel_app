import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_dto.freezed.dart';
part 'message_dto.g.dart';

@freezed
abstract class MessageDto with _$MessageDto {
  const factory MessageDto({
    required String id,
    @JsonKey(name: 'conversation_id') required String conversationId,
    @JsonKey(name: 'sender_id') required String senderId,
    @JsonKey(name: 'encrypted_payload') required String encryptedPayload,
    required String nonce,
    @JsonKey(name: 'sequence_number') required int sequenceNumber,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
}
