// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messaging_activation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessagingActivationDto _$MessagingActivationDtoFromJson(
  Map<String, dynamic> json,
) => _MessagingActivationDto(
  userId: json['user_id'] as String,
  status: json['status'] as String,
  consentAccepted: json['consent_accepted'] as bool? ?? false,
  termsVersion: json['terms_version'] as String? ?? '',
  currentTermsVersion: json['current_terms_version'] as String? ?? '',
  requiresTermsAcceptance: json['requires_terms_acceptance'] as bool? ?? false,
  deviceId: json['device_id'] as String?,
  activatedAt: json['activated_at'] == null
      ? null
      : DateTime.parse(json['activated_at'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$MessagingActivationDtoToJson(
  _MessagingActivationDto instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'status': instance.status,
  'consent_accepted': instance.consentAccepted,
  'terms_version': instance.termsVersion,
  'current_terms_version': instance.currentTermsVersion,
  'requires_terms_acceptance': instance.requiresTermsAcceptance,
  'device_id': instance.deviceId,
  'activated_at': instance.activatedAt?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

_MessagingTermsDto _$MessagingTermsDtoFromJson(Map<String, dynamic> json) =>
    _MessagingTermsDto(
      version: json['version'] as String,
      text: json['text'] as String,
      publishedAt: json['published_at'] == null
          ? null
          : DateTime.parse(json['published_at'] as String),
    );

Map<String, dynamic> _$MessagingTermsDtoToJson(_MessagingTermsDto instance) =>
    <String, dynamic>{
      'version': instance.version,
      'text': instance.text,
      'published_at': instance.publishedAt?.toIso8601String(),
    };
