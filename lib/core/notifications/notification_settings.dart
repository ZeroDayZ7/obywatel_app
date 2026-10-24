import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_settings.freezed.dart';
part 'notification_settings.g.dart';

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

  static NotificationSettings readFromPreferences(
    SharedPreferencesService prefs,
  ) {
    return NotificationSettings(
      appNotifications: prefs.readBool('notif_app') ?? true,
      sound: prefs.readBool('notif_sound') ?? true,
      vibration: prefs.readBool('notif_vib') ?? true,
      email: prefs.readBool('notif_email') ?? false,
      sms: prefs.readBool('notif_sms') ?? false,
    );
  }
}

@riverpod
class AppNotificationSettings extends _$AppNotificationSettings {
  static const _kApp = 'notif_app';
  static const _kSound = 'notif_sound';
  static const _kVib = 'notif_vib';
  static const _kEmail = 'notif_email';
  static const _kSms = 'notif_sms';

  SharedPreferencesService get _prefs => ref.read(activePrefsProvider);

  @override
  NotificationSettings build() {
    try {
      return NotificationSettings.readFromPreferences(_prefs);
    } catch (error, stackTrace) {
      final logger = ref.read(appLoggerProvider);
      logger.e(
        'Failed to initialize notification settings from storage',
        module: 'NotificationSettings',
        error: error,
        stackTrace: stackTrace,
      );
      return const NotificationSettings();
    }
  }

  Future<void> _updateSetting({
    required String key,
    required bool value,
    required NotificationSettings Function(NotificationSettings old) copyWith,
  }) async {
    final previous = state;
    state = copyWith(state);

    try {
      await _prefs.writeBool(key, value);
    } catch (error, stackTrace) {
      state = previous;
      final logger = ref.read(appLoggerProvider);
      logger.e(
        'Failed to persist notification setting: $key',
        module: 'NotificationSettings',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> toggleApp(bool value) => _updateSetting(
        key: _kApp,
        value: value,
        copyWith: (old) => old.copyWith(appNotifications: value),
      );

  Future<void> toggleSound(bool value) => _updateSetting(
        key: _kSound,
        value: value,
        copyWith: (old) => old.copyWith(sound: value),
      );

  Future<void> toggleVibration(bool value) => _updateSetting(
        key: _kVib,
        value: value,
        copyWith: (old) => old.copyWith(vibration: value),
      );

  Future<void> toggleEmail(bool value) => _updateSetting(
        key: _kEmail,
        value: value,
        copyWith: (old) => old.copyWith(email: value),
      );

  Future<void> toggleSms(bool value) => _updateSetting(
        key: _kSms,
        value: value,
        copyWith: (old) => old.copyWith(sms: value),
      );
}