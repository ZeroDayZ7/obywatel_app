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
      isSensitive: json['isSensitive'] as bool? ?? false,
    );

Map<String, dynamic> _$DocumentFieldToJson(_DocumentField instance) =>
    <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
      'iconName': instance.iconName,
      'isSensitive': instance.isSensitive,
    };

_DocumentModel _$DocumentModelFromJson(Map<String, dynamic> json) =>
    _DocumentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      iconName: json['iconName'] as String,
      colorHex: json['colorHex'] as String,
      category: $enumDecode(_$DocumentCategoryEnumMap, json['category']),
      fields: (json['fields'] as List<dynamic>)
          .map((e) => DocumentField.fromJson(e as Map<String, dynamic>))
          .toList(),
      qrData: json['qrData'] as String?,
      status: json['status'] as String?,
      isVerified: json['isVerified'] as bool? ?? false,
      subtitle: json['subtitle'] as String?,
      expiryDate: json['expiryDate'] as String?,
    );

Map<String, dynamic> _$DocumentModelToJson(_DocumentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'iconName': instance.iconName,
      'colorHex': instance.colorHex,
      'category': _$DocumentCategoryEnumMap[instance.category]!,
      'fields': instance.fields,
      'qrData': instance.qrData,
      'status': instance.status,
      'isVerified': instance.isVerified,
      'subtitle': instance.subtitle,
      'expiryDate': instance.expiryDate,
    };

const _$DocumentCategoryEnumMap = {
  DocumentCategory.identity: 'identity',
  DocumentCategory.work: 'work',
  DocumentCategory.education: 'education',
  DocumentCategory.transport: 'transport',
};
