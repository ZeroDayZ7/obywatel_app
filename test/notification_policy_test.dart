import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:obywatel_plus/core/notifications/feedback_service.dart';
import 'package:obywatel_plus/core/notifications/feedback_type.dart';
import 'package:obywatel_plus/core/notifications/notification_settings.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';

class _MockSharedPreferencesService extends Mock
    implements SharedPreferencesService {}

class _RecordingFeedbackPlatform implements FeedbackPlatform {
  _RecordingFeedbackPlatform({this.hasVibratorValue = true});

  final bool hasVibratorValue;
  int vibrateCalls = 0;
  int soundCalls = 0;
  SystemSoundType? lastSound;

  @override
  Future<bool> hasVibrator() async => hasVibratorValue;

  @override
  Future<void> vibrate({
    List<int>? pattern,
    int? duration,
    List<int>? intensities,
  }) async {
    vibrateCalls += 1;
  }

  @override
  Future<void> playSound(SystemSoundType sound) async {
    soundCalls += 1;
    lastSound = sound;
  }
}

void main() {
  group('Notification feedback policy', () {
    test('global sound enabled + module inherits => allowed', () {
      const policy = ModuleFeedbackPolicy(
        moduleId: NotificationModuleId.communication,
      );
      expect(policy.isSoundEnabled(globalEnabled: true), isTrue);
    });

    test('global sound enabled + module disabled => blocked', () {
      const policy = ModuleFeedbackPolicy(
        moduleId: NotificationModuleId.communication,
        sound: NotificationOverrideMode.disabled,
      );
      expect(policy.isSoundEnabled(globalEnabled: true), isFalse);
    });

    test('global sound disabled + module enabled => blocked', () {
      const policy = ModuleFeedbackPolicy(
        moduleId: NotificationModuleId.communication,
        sound: NotificationOverrideMode.enabled,
      );
      expect(policy.isSoundEnabled(globalEnabled: false), isFalse);
    });

    test('global vibration enabled + module inherits => allowed', () {
      const policy = ModuleFeedbackPolicy(
        moduleId: NotificationModuleId.communication,
      );
      expect(policy.isVibrationEnabled(globalEnabled: true), isTrue);
    });

    test('global vibration enabled + module disabled => blocked', () {
      const policy = ModuleFeedbackPolicy(
        moduleId: NotificationModuleId.communication,
        vibration: NotificationOverrideMode.disabled,
      );
      expect(policy.isVibrationEnabled(globalEnabled: true), isFalse);
    });

    test('global vibration disabled + module enabled => blocked', () {
      const policy = ModuleFeedbackPolicy(
        moduleId: NotificationModuleId.communication,
        vibration: NotificationOverrideMode.enabled,
      );
      expect(policy.isVibrationEnabled(globalEnabled: false), isFalse);
    });

    test('communication override does not affect other modules', () {
      const communication = ModuleFeedbackPolicy(
        moduleId: NotificationModuleId.communication,
        sound: NotificationOverrideMode.disabled,
        vibration: NotificationOverrideMode.disabled,
      );
      const general = ModuleFeedbackPolicy(moduleId: NotificationModuleId.general);

      expect(communication.isSoundEnabled(globalEnabled: true), isFalse);
      expect(general.isSoundEnabled(globalEnabled: true), isTrue);
      expect(communication.isVibrationEnabled(globalEnabled: true), isFalse);
      expect(general.isVibrationEnabled(globalEnabled: true), isTrue);
    });

    test('persisted overrides are restored from SharedPreferences', () {
      final prefs = _MockSharedPreferencesService();
      when(() => prefs.read('notif_module_communication_sound')).thenReturn('disabled');
      when(() => prefs.read('notif_module_communication_vibration')).thenReturn('enabled');

      final state = ModuleNotificationSettings.readAll(prefs);
      expect(state[NotificationModuleId.communication]!.sound, NotificationOverrideMode.disabled);
      expect(state[NotificationModuleId.communication]!.vibration, NotificationOverrideMode.enabled);
    });

    test('save failure restores previous state', () async {
      final prefs = _MockSharedPreferencesService();
      when(() => prefs.read('notif_module_communication_sound')).thenReturn(null);
      when(() => prefs.write('notif_module_communication_sound', 'disabled')).thenThrow(Exception('write failed'));

      final container = ProviderContainer(
        overrides: [activePrefsProvider.overrideWithValue(prefs)],
      );
      final notifier = container.read(moduleNotificationSettingsProvider.notifier);

      await notifier.setOverride(
        moduleId: NotificationModuleId.communication,
        effect: NotificationFeedbackEffect.sound,
        mode: NotificationOverrideMode.disabled,
      );

      expect(
        container.read(moduleNotificationSettingsProvider)
            [NotificationModuleId.communication]!
            .sound,
        NotificationOverrideMode.inherit,
      );
    });

    test('device without vibration does not throw', () async {
      final platform = _RecordingFeedbackPlatform(hasVibratorValue: false);
      final container = ProviderContainer(
        overrides: [
          appNotificationSettingsProvider.overrideWithValue(
            const NotificationSettings(
              appNotifications: true,
              sound: true,
              vibration: true,
            ),
          ),
          moduleNotificationSettingsProvider.overrideWithValue({
            NotificationModuleId.communication: const ModuleFeedbackPolicy(
              moduleId: NotificationModuleId.communication,
            ),
          }),
          feedbackServiceProvider.overrideWith(
            (ref) => FeedbackService(ref, platform: platform),
          ),
        ],
      );

      await container.read(feedbackServiceProvider).trigger(
        FeedbackType.error,
        moduleId: NotificationModuleId.communication,
      );

      expect(platform.vibrateCalls, 0);
      expect(platform.soundCalls, 1);
    });

    test('legacy preference keys are read correctly', () {
      final prefs = _MockSharedPreferencesService();
      when(() => prefs.readBool('notif_app')).thenReturn(true);
      when(() => prefs.readBool('notif_sound')).thenReturn(false);
      when(() => prefs.readBool('notif_vib')).thenReturn(true);
      when(() => prefs.readBool('notif_email')).thenReturn(false);
      when(() => prefs.readBool('notif_sms')).thenReturn(false);

      final settings = NotificationSettings.readFromPreferences(prefs);
      expect(settings.appNotifications, isTrue);
      expect(settings.sound, isFalse);
      expect(settings.vibration, isTrue);
      expect(settings.email, isFalse);
      expect(settings.sms, isFalse);
    });
  });
}
