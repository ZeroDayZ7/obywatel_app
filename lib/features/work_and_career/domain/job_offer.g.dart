// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobOffer _$JobOfferFromJson(Map<String, dynamic> json) => _JobOffer(
  id: json['id'] as String,
  title: json['title'] as String,
  company: json['company'] as String,
  location: json['location'] as String,
  salary: json['salary'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$JobOfferToJson(_JobOffer instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'company': instance.company,
  'location': instance.location,
  'salary': instance.salary,
  'type': instance.type,
};
