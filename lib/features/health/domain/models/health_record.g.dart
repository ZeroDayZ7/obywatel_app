// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HealthRecord _$HealthRecordFromJson(Map<String, dynamic> json) =>
    _HealthRecord(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      type: $enumDecode(_$HealthRecordTypeEnumMap, json['type']),
      status: json['status'] as String,
      description: json['description'] as String?,
      doctorName: json['doctorName'] as String?,
    );

Map<String, dynamic> _$HealthRecordToJson(_HealthRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'date': instance.date.toIso8601String(),
      'type': _$HealthRecordTypeEnumMap[instance.type]!,
      'status': instance.status,
      'description': instance.description,
      'doctorName': instance.doctorName,
    };

const _$HealthRecordTypeEnumMap = {
  HealthRecordType.prescriptions: 'prescriptions',
  HealthRecordType.referrals: 'referrals',
  HealthRecordType.history: 'history',
  HealthRecordType.vaccinations: 'vaccinations',
};
