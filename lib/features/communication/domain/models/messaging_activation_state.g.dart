// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messaging_activation_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessagingActivationState _$MessagingActivationStateFromJson(
  Map<String, dynamic> json,
) => _MessagingActivationState(
  status: json['status'] == null
      ? null
      : MessagingActivationDto.fromJson(json['status'] as Map<String, dynamic>),
  terms: json['terms'] == null
      ? null
      : MessagingTermsDto.fromJson(json['terms'] as Map<String, dynamic>),
  errorMessage: json['errorMessage'] as String?,
  keyRegistrationStatus:
      json['keyRegistrationStatus'] as String? ?? 'not_started',
);

Map<String, dynamic> _$MessagingActivationStateToJson(
  _MessagingActivationState instance,
) => <String, dynamic>{
  'status': instance.status,
  'terms': instance.terms,
  'errorMessage': instance.errorMessage,
  'keyRegistrationStatus': instance.keyRegistrationStatus,
};
