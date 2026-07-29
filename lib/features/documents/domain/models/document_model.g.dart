// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DocumentField _$DocumentFieldFromJson(Map<String, dynamic> json) =>
    _DocumentField(
      label: json['label'] as String,
      value: json['value'] as String,
      iconName: json['iconName'] as String,
    );

Map<String, dynamic> _$DocumentFieldToJson(_DocumentField instance) =>
    <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
      'iconName': instance.iconName,
    };

_DocumentModel _$DocumentModelFromJson(Map<String, dynamic> json) =>
    _DocumentModel(
      id: json['id'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      metadata: json['metadata'] as Map<String, dynamic>,
      fields: (json['fields'] as List<dynamic>)
          .map((e) => DocumentField.fromJson(e as Map<String, dynamic>))
          .toList(),
      profileId: json['profileId'] as String?,
      issuedAt: json['issuedAt'] as String?,
      expiresAt: json['expiresAt'] as String?,
      qrData: json['qrData'] as String?,
    );

Map<String, dynamic> _$DocumentModelToJson(_DocumentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'status': instance.status,
      'metadata': instance.metadata,
      'fields': instance.fields,
      'profileId': instance.profileId,
      'issuedAt': instance.issuedAt,
      'expiresAt': instance.expiresAt,
      'qrData': instance.qrData,
    };
