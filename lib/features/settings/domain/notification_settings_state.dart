import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_settings_state.freezed.dart';
part 'notification_settings_state.g.dart';

@freezed
sealed class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    @Default(true) bool appNotifications,
    @Default(true) bool sound,
    @Default(true) bool vibration,
    @Default(false) bool email,
    @Default(false) bool sms,
  }) = _NotificationSettings;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}
