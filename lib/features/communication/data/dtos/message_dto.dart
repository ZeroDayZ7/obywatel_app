// lib/features/communication/data/dtos/message_dto.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_dto.freezed.dart';
part 'message_dto.g.dart';

@freezed
abstract class MessageDto with _$MessageDto {
  const factory MessageDto({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'conversation_id') required String conversationId,
    @JsonKey(name: 'sender_id') required String senderId,
    @JsonKey(name: 'sender_device_id') String? senderDeviceId,
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'sequence') @Default(0) int sequence,
    @JsonKey(name: 'version') @Default(1) int version,
    @JsonKey(name: 'encrypted_payload') @Default('') String encryptedPayload,
    @JsonKey(name: 'nonce') String? nonce,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
}
