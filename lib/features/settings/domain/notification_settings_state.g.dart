// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_settings_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationSettings _$NotificationSettingsFromJson(
  Map<String, dynamic> json,
) => _NotificationSettings(
  appNotifications: json['appNotifications'] as bool? ?? true,
  sound: json['sound'] as bool? ?? true,
  vibration: json['vibration'] as bool? ?? true,
  email: json['email'] as bool? ?? false,
  sms: json['sms'] as bool? ?? false,
);

Map<String, dynamic> _$NotificationSettingsToJson(
  _NotificationSettings instance,
) => <String, dynamic>{
  'appNotifications': instance.appNotifications,
  'sound': instance.sound,
  'vibration': instance.vibration,
  'email': instance.email,
  'sms': instance.sms,
};
