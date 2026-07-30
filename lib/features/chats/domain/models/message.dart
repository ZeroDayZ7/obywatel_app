import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';

@freezed
abstract class Message with _$Message {
  const factory Message({
    required String id,
    required String conversationId,
    required String senderId,
    required String content,
    required bool isMine,
    required DateTime createdAt,
    @Default(true) bool isEncrypted,
  }) = _Message;
}