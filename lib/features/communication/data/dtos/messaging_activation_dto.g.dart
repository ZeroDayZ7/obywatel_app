// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messaging_activation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessagingActivationDto _$MessagingActivationDtoFromJson(
  Map<String, dynamic> json,
) => _MessagingActivationDto(
  userId: json['userId'] as String,
  status: json['status'] as String,
  consentAccepted: json['consentAccepted'] as bool? ?? false,
  termsVersion: json['termsVersion'] as String? ?? '',
  currentTermsVersion: json['currentTermsVersion'] as String? ?? '',
  requiresTermsAcceptance: json['requiresTermsAcceptance'] as bool? ?? false,
  deviceId: json['deviceId'] as String?,
  activatedAt: json['activatedAt'] == null
      ? null
      : DateTime.parse(json['activatedAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$MessagingActivationDtoToJson(
  _MessagingActivationDto instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'status': instance.status,
  'consentAccepted': instance.consentAccepted,
  'termsVersion': instance.termsVersion,
  'currentTermsVersion': instance.currentTermsVersion,
  'requiresTermsAcceptance': instance.requiresTermsAcceptance,
  'deviceId': instance.deviceId,
  'activatedAt': instance.activatedAt?.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

_MessagingTermsDto _$MessagingTermsDtoFromJson(Map<String, dynamic> json) =>
    _MessagingTermsDto(
      version: json['version'] as String,
      text: json['text'] as String,
      publishedAt: json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
    );

Map<String, dynamic> _$MessagingTermsDtoToJson(_MessagingTermsDto instance) =>
    <String, dynamic>{
      'version': instance.version,
      'text': instance.text,
      'publishedAt': instance.publishedAt?.toIso8601String(),
    };
