// lib/features/communication/data/dtos/message_dto.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_dto.freezed.dart';
part 'message_dto.g.dart';

String _stringFromJson(Object? value) => value?.toString() ?? '';
String? _nullableStringFromJson(Object? value) => value?.toString();

@freezed
abstract class MessageDto with _$MessageDto {
  const factory MessageDto({
    @JsonKey(name: 'id', fromJson: _stringFromJson) required String id,
    @JsonKey(name: 'conversationId', fromJson: _stringFromJson)
    required String conversationId,
    @JsonKey(name: 'senderId', fromJson: _stringFromJson) required String senderId,
    @JsonKey(name: 'senderDeviceId', fromJson: _nullableStringFromJson)
    String? senderDeviceId,
    @JsonKey(name: 'attachmentId', fromJson: _nullableStringFromJson)
    String? attachmentId,
    @JsonKey(name: 'type', fromJson: _stringFromJson) required String type,
    @JsonKey(name: 'sequence') @Default(0) int sequence,
    @JsonKey(name: 'version') @Default(1) int version,
    @JsonKey(name: 'encryptedPayload') @Default('') String encryptedPayload,
    @JsonKey(name: 'nonce') String? nonce,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
}
