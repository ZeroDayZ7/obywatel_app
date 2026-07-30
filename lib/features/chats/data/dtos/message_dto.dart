// lib/features/chats/data/dtos/message_dto.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_dto.freezed.dart';
part 'message_dto.g.dart';

@freezed
abstract class MessageDto with _$MessageDto {
  const factory MessageDto({
    @JsonKey(name: 'ID') required String id,
    @JsonKey(name: 'ConversationID') required String conversationId,
    @JsonKey(name: 'SenderID') required String senderId,
    @JsonKey(name: 'SenderDeviceID') String? senderDeviceId,
    @JsonKey(name: 'Type') required String type,
    @JsonKey(name: 'Sequence') @Default(0) int sequence,
    @JsonKey(name: 'Version') @Default(1) int version,
    @JsonKey(name: 'EncryptedPayload') @Default('') String encryptedPayload,
    @JsonKey(name: 'Nonce') String? nonce,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
}