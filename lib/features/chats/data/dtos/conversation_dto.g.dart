// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConversationDto _$ConversationDtoFromJson(Map<String, dynamic> json) =>
    _ConversationDto(
      id: json['id'] as String,
      participantIds: (json['participant_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastMessage: json['last_message'] == null
          ? null
          : MessageDto.fromJson(json['last_message'] as Map<String, dynamic>),
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ConversationDtoToJson(_ConversationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participant_ids': instance.participantIds,
      'last_message': instance.lastMessage,
      'unread_count': instance.unreadCount,
      'updated_at': instance.updatedAt.toIso8601String(),
    };
