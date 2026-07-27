// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DocumentModel _$DocumentModelFromJson(Map<String, dynamic> json) =>
    _DocumentModel(
      id: json['id'] as String? ?? '',
      profileId: json['profile_id'] as String?,
      type: json['type'] as String? ?? '',
      status: json['status'] as String? ?? '',
      encryptedMeta: json['encrypted_meta'] as String? ?? '',
      issuedAt: json['issued_at'] as String?,
      expiresAt: json['expires_at'] as String?,
    );

Map<String, dynamic> _$DocumentModelToJson(_DocumentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'profile_id': instance.profileId,
      'type': instance.type,
      'status': instance.status,
      'encrypted_meta': instance.encryptedMeta,
      'issued_at': instance.issuedAt,
      'expires_at': instance.expiresAt,
    };
