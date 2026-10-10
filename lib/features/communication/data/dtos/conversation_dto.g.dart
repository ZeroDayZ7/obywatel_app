// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationMemberDto _$ConversationMemberDtoFromJson(
  Map<String, dynamic> json,
) => _ConversationMemberDto(
  id: json['id'] as String,
  conversationId: json['conversation_id'] as String,
  userId: json['user_id'] as String,
  role: json['role'] as String,
  lastReadSequence: (json['last_read_sequence'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ConversationMemberDtoToJson(
  _ConversationMemberDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'conversation_id': instance.conversationId,
  'user_id': instance.userId,
  'role': instance.role,
  'last_read_sequence': instance.lastReadSequence,
};

_ConversationDto _$ConversationDtoFromJson(Map<String, dynamic> json) =>
    _ConversationDto(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String?,
      lastSequence: (json['last_sequence'] as num?)?.toInt() ?? 0,
      members:
          (json['members'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ConversationMemberDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      messages: (json['messages'] as List<dynamic>?)
          ?.map(
            (e) => e == null
                ? null
                : MessageDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ConversationDtoToJson(_ConversationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'last_sequence': instance.lastSequence,
      'members': instance.members,
      'messages': instance.messages,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
