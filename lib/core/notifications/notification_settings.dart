import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_settings.freezed.dart';
part 'notification_settings.g.dart';

enum NotificationOverrideMode {
  inherit,
  enabled,
  disabled,
}

enum NotificationModuleId {
  general('general'),
  communication('communication'),
  exchange('exchange'),
  settings('settings');

  const NotificationModuleId(this.storageKey);

  final String storageKey;
}

enum NotificationFeedbackEffect {
  sound('sound'),
  vibration('vibration');

  const NotificationFeedbackEffect(this.storageKey);

  final String storageKey;
}

class ModuleFeedbackPolicy {
  const ModuleFeedbackPolicy({
    required this.moduleId,
    this.sound = NotificationOverrideMode.inherit,
    this.vibration = NotificationOverrideMode.inherit,
  });

  final NotificationModuleId moduleId;
  final NotificationOverrideMode sound;
  final NotificationOverrideMode vibration;

  bool isSoundEnabled({required bool globalEnabled}) =>
      _resolve(globalEnabled, sound);

  bool isVibrationEnabled({required bool globalEnabled}) =>
      _resolve(globalEnabled, vibration);

  static bool _resolve(bool globalEnabled, NotificationOverrideMode mode) {
    if (!globalEnabled) {
      return false;
    }

    switch (mode) {
      case NotificationOverrideMode.inherit:
      case NotificationOverrideMode.enabled:
        return true;
      case NotificationOverrideMode.disabled:
        return false;
    }
  }

  ModuleFeedbackPolicy copyWith({
    NotificationModuleId? moduleId,
    NotificationOverrideMode? sound,
    NotificationOverrideMode? vibration,
  }) {
    return ModuleFeedbackPolicy(
      moduleId: moduleId ?? this.moduleId,
      sound: sound ?? this.sound,
      vibration: vibration ?? this.vibration,
    );
  }

  static String keyFor(
    NotificationModuleId moduleId,
    NotificationFeedbackEffect effect,
  ) =>
      'notif_module_${moduleId.storageKey}_${effect.storageKey}';
}

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

@riverpod
class ModuleNotificationSettings extends _$ModuleNotificationSettings {
  SharedPreferencesService get _prefs => ref.read(activePrefsProvider);

  @override
  Map<NotificationModuleId, ModuleFeedbackPolicy> build() {
    return readAll(_prefs);
  }

  static Map<NotificationModuleId, ModuleFeedbackPolicy> readAll(
    SharedPreferencesService prefs,
  ) {
    final entries = <NotificationModuleId, ModuleFeedbackPolicy>{};

    for (final moduleId in NotificationModuleId.values) {
      entries[moduleId] = ModuleFeedbackPolicy(
        moduleId: moduleId,
        sound: _readMode(prefs, moduleId, NotificationFeedbackEffect.sound),
        vibration: _readMode(
          prefs,
          moduleId,
          NotificationFeedbackEffect.vibration,
        ),
      );
    }

    return entries;
  }

  static NotificationOverrideMode _readMode(
    SharedPreferencesService prefs,
    NotificationModuleId moduleId,
    NotificationFeedbackEffect effect,
  ) {
    final rawValue = prefs.read(ModuleFeedbackPolicy.keyFor(moduleId, effect));
    switch (rawValue) {
      case 'enabled':
        return NotificationOverrideMode.enabled;
      case 'disabled':
        return NotificationOverrideMode.disabled;
      default:
        return NotificationOverrideMode.inherit;
    }
  }

  ModuleFeedbackPolicy policyFor(NotificationModuleId moduleId) {
    return state[moduleId] ?? ModuleFeedbackPolicy(moduleId: moduleId);
  }

  Future<void> setOverride({
    required NotificationModuleId moduleId,
    required NotificationFeedbackEffect effect,
    required NotificationOverrideMode mode,
  }) async {
    final previous = policyFor(moduleId);
    final next = switch (effect) {
      NotificationFeedbackEffect.sound => previous.copyWith(sound: mode),
      NotificationFeedbackEffect.vibration => previous.copyWith(
          vibration: mode,
        ),
    };

    state = {
      ...state,
      moduleId: next,
    };

    try {
      await _prefs.write(ModuleFeedbackPolicy.keyFor(moduleId, effect), mode.name);
    } catch (_) {
      state = {
        ...state,
        moduleId: previous,
      };
    }
  }
}