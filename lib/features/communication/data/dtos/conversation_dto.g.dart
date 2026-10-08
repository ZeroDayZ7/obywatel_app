// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationMemberDto _$ConversationMemberDtoFromJson(
  Map<String, dynamic> json,
) => _ConversationMemberDto(
  id: json['ID'] as String,
  conversationId: json['ConversationID'] as String,
  userId: json['UserID'] as String,
  role: json['Role'] as String,
  lastReadSequence: (json['LastReadSequence'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$ConversationMemberDtoToJson(
  _ConversationMemberDto instance,
) => <String, dynamic>{
  'ID': instance.id,
  'ConversationID': instance.conversationId,
  'UserID': instance.userId,
  'Role': instance.role,
  'LastReadSequence': instance.lastReadSequence,
};

_ConversationDto _$ConversationDtoFromJson(Map<String, dynamic> json) =>
    _ConversationDto(
      id: json['ID'] as String,
      type: json['Type'] as String,
      title: json['Title'] as String?,
      lastSequence: (json['LastSequence'] as num?)?.toInt() ?? 0,
      members:
          (json['Members'] as List<dynamic>?)
              ?.map(
                (e) =>
                    ConversationMemberDto.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      messages: (json['Messages'] as List<dynamic>?)
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
      'ID': instance.id,
      'Type': instance.type,
      'Title': instance.title,
      'LastSequence': instance.lastSequence,
      'Members': instance.members,
      'Messages': instance.messages,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
