import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/notifications/feedback_service.dart';
import 'package:obywatel_plus/core/notifications/feedback_type.dart';
import 'package:obywatel_plus/core/notifications/notification_settings.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class RecordingFeedbackPlatform implements FeedbackPlatform {
  RecordingFeedbackPlatform({this.hasVibratorValue = true});

  final bool hasVibratorValue;
  int vibrateCalls = 0;
  int soundCalls = 0;

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
  }
}

void main() {
  group('global notification policy', () {
    late MockSharedPreferences prefs;

    setUp(() {
      prefs = MockSharedPreferences();
      when(() => prefs.getBool('notif_app')).thenReturn(true);
      when(() => prefs.getBool('notif_sound')).thenReturn(true);
      when(() => prefs.getBool('notif_vib')).thenReturn(true);
      when(() => prefs.getBool('notif_email')).thenReturn(false);
      when(() => prefs.getBool('notif_sms')).thenReturn(false);
      when(() => prefs.setBool(any(), any())).thenAnswer((_) async => true);
    });

    test('global appNotifications false blocks all effects', () async {
      final platform = RecordingFeedbackPlatform();
      final container = ProviderContainer(
        overrides: [
          activePrefsProvider.overrideWithValue(
            SharedPreferencesService(prefs, AppLogger()),
          ),
        ],
      );

      container.read(appNotificationSettingsProvider.notifier).state =
          const NotificationSettings(
            appNotifications: false,
            sound: true,
            vibration: true,
          );

      final service = FeedbackService(container, platform: platform);
      await service.trigger(FeedbackType.error);

      expect(platform.soundCalls, 0);
      expect(platform.vibrateCalls, 0);
    });

    test('sound disabled keeps vibration active', () async {
      final platform = RecordingFeedbackPlatform();
      final container = ProviderContainer(
        overrides: [
          activePrefsProvider.overrideWithValue(
            SharedPreferencesService(prefs, AppLogger()),
          ),
        ],
      );

      container.read(appNotificationSettingsProvider.notifier).state =
          const NotificationSettings(
            appNotifications: true,
            sound: false,
            vibration: true,
          );

      final service = FeedbackService(container, platform: platform);
      await service.trigger(FeedbackType.error);

      expect(platform.soundCalls, 0);
      expect(platform.vibrateCalls, 1);
    });

    test('vibration disabled keeps sound active', () async {
      final platform = RecordingFeedbackPlatform();
      final container = ProviderContainer(
        overrides: [
          activePrefsProvider.overrideWithValue(
            SharedPreferencesService(prefs, AppLogger()),
          ),
        ],
      );

      container.read(appNotificationSettingsProvider.notifier).state =
          const NotificationSettings(
            appNotifications: true,
            sound: true,
            vibration: false,
          );

      final service = FeedbackService(container, platform: platform);
      await service.trigger(FeedbackType.error);

      expect(platform.soundCalls, 1);
      expect(platform.vibrateCalls, 0);
    });

    test('sound and vibration enabled trigger both effects', () async {
      final platform = RecordingFeedbackPlatform();
      final container = ProviderContainer(
        overrides: [
          activePrefsProvider.overrideWithValue(
            SharedPreferencesService(prefs, AppLogger()),
          ),
        ],
      );

      container.read(appNotificationSettingsProvider.notifier).state =
          const NotificationSettings(
            appNotifications: true,
            sound: true,
            vibration: true,
          );

      final service = FeedbackService(container, platform: platform);
      await service.trigger(FeedbackType.error);

      expect(platform.soundCalls, 1);
      expect(platform.vibrateCalls, 1);
    });
  });
}
