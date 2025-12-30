import 'package:obywatel_plus/core/storage/shared_preferences_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'notification_settings_state.dart';

part 'notification_settings_notifier.g.dart';

@riverpod
class NotificationSettingsNotifier extends _$NotificationSettingsNotifier {
  // Klucze do SharedPreferences
  static const _kApp = 'notif_app';
  static const _kSound = 'notif_sound';
  static const _kVib = 'notif_vib';
  static const _kEmail = 'notif_email';
  static const _kSms = 'notif_sms';

  SharedPreferencesService get _prefs => ref.read(activePrefsProvider);

  @override
  NotificationSettings build() {
    // Inicjalizacja stanu z pamięci urządzenia (synchronicznie!)
    return NotificationSettings(
      appNotifications: _prefs.readBool(_kApp) ?? true,
      sound: _prefs.readBool(_kSound) ?? true,
      vibration: _prefs.readBool(_kVib) ?? true,
      email: _prefs.readBool(_kEmail) ?? false,
      sms: _prefs.readBool(_kSms) ?? false,
    );
  }

  /// Wspólna metoda do aktualizacji ustawień
  Future<void> _updateSetting({
    required String key,
    required bool value,
    required NotificationSettings Function(NotificationSettings old) copyWith,
  }) async {
    // 1. Optymistyczna aktualizacja UI (natychmiastowa reakcja switcha)
    state = copyWith(state);

    try {
      // 2. Zapis lokalny (SharedPrefs)
      await _prefs.writeBool(key, value);

      // 3. TUTAJ: Miejsce na wysłanie zmiany do API (np. updateNotifications na backendzie)
      // await ref.read(apiServiceProvider).updateNotificationSettings(key, value);
    } catch (e) {
      // W razie błędu przywracamy poprzedni stan (opcjonalnie)
      // state = oldState;
    }
  }

  // Metody publiczne dla widoku
  void toggleApp(bool v) => _updateSetting(
    key: _kApp,
    value: v,
    copyWith: (old) => old.copyWith(appNotifications: v),
  );

  void toggleSound(bool v) => _updateSetting(
    key: _kSound,
    value: v,
    copyWith: (old) => old.copyWith(sound: v),
  );

  void toggleVibration(bool v) => _updateSetting(
    key: _kVib,
    value: v,
    copyWith: (old) => old.copyWith(vibration: v),
  );

  void toggleEmail(bool v) => _updateSetting(
    key: _kEmail,
    value: v,
    copyWith: (old) => old.copyWith(email: v),
  );

  void toggleSms(bool v) => _updateSetting(
    key: _kSms,
    value: v,
    copyWith: (old) => old.copyWith(sms: v),
  );
}
