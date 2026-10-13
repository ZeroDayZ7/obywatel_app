// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContactDto _$ContactDtoFromJson(Map<String, dynamic> json) => _ContactDto(
  id: json['id'] as String,
  ownerId: json['ownerId'] as String,
  contactId: json['contactId'] as String,
  status: json['status'] as String,
  direction: json['direction'] as String,
  localAlias: json['localAlias'] as String?,
  version: (json['version'] as num).toInt(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ContactDtoToJson(_ContactDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'contactId': instance.contactId,
      'status': instance.status,
      'direction': instance.direction,
      'localAlias': instance.localAlias,
      'version': instance.version,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
