import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';

part 'conversation.freezed.dart';

@freezed
abstract class ConversationMember with _$ConversationMember {
  const factory ConversationMember({
    required String id,
    required String conversationId,
    required String userId,
    required String role,
    required int lastReadSequence,
  }) = _ConversationMember;
}

@freezed
abstract class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    required String type,
    String? title,
    @Default(0) int lastSequence,
    @Default([]) List<ConversationMember> members,
    List<Message?>? messages,
    DateTime? updatedAt,
  }) = _Conversation;
}
