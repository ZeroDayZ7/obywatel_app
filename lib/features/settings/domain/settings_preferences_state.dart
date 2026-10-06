import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_preferences_state.freezed.dart';
part 'settings_preferences_state.g.dart';

enum AppLockTimeout {
  immediate,
  seconds30,
  minute1,
  fiveMinutes,
}

@freezed
sealed class SettingsPreferencesState with _$SettingsPreferencesState {
  const factory SettingsPreferencesState({
    @Default(AppLockTimeout.minute1) AppLockTimeout appLockTimeout,
    @Default(true) bool biometricPrompt,
  }) = _SettingsPreferencesState;

  factory SettingsPreferencesState.fromJson(Map<String, dynamic> json) =>
      _$SettingsPreferencesStateFromJson(json);
}