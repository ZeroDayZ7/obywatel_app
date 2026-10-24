// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messaging_activation_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessagingActivationState _$MessagingActivationStateFromJson(
  Map<String, dynamic> json,
) => _MessagingActivationState(
  userId: json['userId'] as String?,
  deviceId: json['deviceId'] as String?,
  status: json['status'] as String?,
  consentAccepted: json['consentAccepted'] as bool? ?? false,
  termsVersion: json['termsVersion'] as String?,
  currentTermsVersion: json['currentTermsVersion'] as String?,
  requiresTermsAcceptance: json['requiresTermsAcceptance'] as bool? ?? false,
  termsText: json['termsText'] as String?,
  hasLocalActivation: json['hasLocalActivation'] as bool? ?? false,
  errorMessage: json['errorMessage'] as String?,
  keyRegistrationStatus:
      json['keyRegistrationStatus'] as String? ?? 'not_started',
);

Map<String, dynamic> _$MessagingActivationStateToJson(
  _MessagingActivationState instance,
) => <String, dynamic>{
  'userId': instance.userId,
  'deviceId': instance.deviceId,
  'status': instance.status,
  'consentAccepted': instance.consentAccepted,
  'termsVersion': instance.termsVersion,
  'currentTermsVersion': instance.currentTermsVersion,
  'requiresTermsAcceptance': instance.requiresTermsAcceptance,
  'termsText': instance.termsText,
  'hasLocalActivation': instance.hasLocalActivation,
  'errorMessage': instance.errorMessage,
  'keyRegistrationStatus': instance.keyRegistrationStatus,
};
