// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DocumentModel _$DocumentModelFromJson(Map<String, dynamic> json) =>
    _DocumentModel(
      id: json['ID'] as String,
      profileId: json['ProfileID'] as String,
      type: json['Type'] as String,
      status: json['Status'] as String,
      encryptedMeta: json['EncryptedMeta'] as String,
      issuedAt: json['IssuedAt'] as String?,
      expiresAt: json['ExpiresAt'] as String?,
      createdAt: json['CreatedAt'] as String?,
      updatedAt: json['UpdatedAt'] as String?,
    );

Map<String, dynamic> _$DocumentModelToJson(_DocumentModel instance) =>
    <String, dynamic>{
      'ID': instance.id,
      'ProfileID': instance.profileId,
      'Type': instance.type,
      'Status': instance.status,
      'EncryptedMeta': instance.encryptedMeta,
      'IssuedAt': instance.issuedAt,
      'ExpiresAt': instance.expiresAt,
      'CreatedAt': instance.createdAt,
      'UpdatedAt': instance.updatedAt,
    };
