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
  privacyMode:
      $enumDecodeNullable(_$PrivacyModeEnumMap, json['privacyMode']) ??
      PrivacyMode.balanced,
  displayMode:
      $enumDecodeNullable(_$DisplayModeEnumMap, json['displayMode']) ??
      DisplayMode.adaptive,
  biometricPrompt: json['biometricPrompt'] as bool? ?? true,
  reducedMotion: json['reducedMotion'] as bool? ?? false,
  dataSharingOptIn: json['dataSharingOptIn'] as bool? ?? false,
);

Map<String, dynamic> _$SettingsPreferencesStateToJson(
  _SettingsPreferencesState instance,
) => <String, dynamic>{
  'appLockTimeout': _$AppLockTimeoutEnumMap[instance.appLockTimeout]!,
  'privacyMode': _$PrivacyModeEnumMap[instance.privacyMode]!,
  'displayMode': _$DisplayModeEnumMap[instance.displayMode]!,
  'biometricPrompt': instance.biometricPrompt,
  'reducedMotion': instance.reducedMotion,
  'dataSharingOptIn': instance.dataSharingOptIn,
};

const _$AppLockTimeoutEnumMap = {
  AppLockTimeout.immediate: 'immediate',
  AppLockTimeout.seconds30: 'seconds30',
  AppLockTimeout.minute1: 'minute1',
  AppLockTimeout.fiveMinutes: 'fiveMinutes',
};

const _$PrivacyModeEnumMap = {
  PrivacyMode.standard: 'standard',
  PrivacyMode.balanced: 'balanced',
  PrivacyMode.strict: 'strict',
};

const _$DisplayModeEnumMap = {
  DisplayMode.adaptive: 'adaptive',
  DisplayMode.compact: 'compact',
  DisplayMode.highContrast: 'highContrast',
};
