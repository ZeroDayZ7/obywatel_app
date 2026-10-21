// lib/features/communication/data/dtos/message_record.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_record.freezed.dart';
part 'message_record.g.dart';

@freezed
abstract class MessageRecord with _$MessageRecord {
  const factory MessageRecord({
    String? id,
    String? messageId,
    String? conversationId,
    String? senderUserId,
    String? senderDeviceId,
    String? recipientUserId,
    String? recipientDeviceId,
    String? ciphertext,
    String? type,
    DateTime? createdAt,
    DateTime? expiresAt,
    @Default(false) bool isDelivered,
    @Default(1) int version,
  }) = _MessageRecord;

  factory MessageRecord.fromJson(Map<String, dynamic> json) =>
      _$MessageRecordFromJson(json);
}