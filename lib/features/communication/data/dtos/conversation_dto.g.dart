// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationMemberDto _$ConversationMemberDtoFromJson(
  Map<String, dynamic> json,
) => _ConversationMemberDto(
  id: _stringFromJson(json['id']),
  conversationId: _stringFromJson(json['conversationId']),
  userId: _stringFromJson(json['userId']),
  role: _stringFromJson(json['role']),
  lastReadSequence: (json['lastReadSequence'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ConversationMemberDtoToJson(
  _ConversationMemberDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'conversationId': instance.conversationId,
  'userId': instance.userId,
  'role': instance.role,
  'lastReadSequence': instance.lastReadSequence,
};

_ConversationDto _$ConversationDtoFromJson(Map<String, dynamic> json) =>
    _ConversationDto(
      id: _stringFromJson(json['id']),
      type: _stringFromJson(json['type']),
      title: _nullableStringFromJson(json['title']),
      lastSequence: (json['lastSequence'] as num?)?.toInt() ?? 0,
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
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ConversationDtoToJson(_ConversationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'lastSequence': instance.lastSequence,
      'members': instance.members,
      'messages': instance.messages,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
