// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_preferences_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsPreferencesState _$SettingsPreferencesStateFromJson(
  Map<String, dynamic> json,
) => _SettingsPreferencesState(
  appLockTimeout:
      $enumDecodeNullable(_$AppLockTimeoutEnumMap, json['appLockTimeout']) ??
      AppLockTimeout.minute1,
  biometricPrompt: json['biometricPrompt'] as bool? ?? true,
);

Map<String, dynamic> _$SettingsPreferencesStateToJson(
  _SettingsPreferencesState instance,
) => <String, dynamic>{
  'appLockTimeout': _$AppLockTimeoutEnumMap[instance.appLockTimeout]!,
  'biometricPrompt': instance.biometricPrompt,
};

const _$AppLockTimeoutEnumMap = {
  AppLockTimeout.immediate: 'immediate',
  AppLockTimeout.seconds30: 'seconds30',
  AppLockTimeout.minute1: 'minute1',
  AppLockTimeout.fiveMinutes: 'fiveMinutes',
};
