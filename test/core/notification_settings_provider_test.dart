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

class _FakeFeedbackPlatform implements FeedbackPlatform {
  int vibrateCalls = 0;
  int soundCalls = 0;

  @override
  Future<bool> hasVibrator() async => true;

  @override
  Future<void> vibrate({List<int>? pattern, int? duration, List<int>? intensities}) async {
    vibrateCalls += 1;
  }

  @override
  Future<void> playSound(SystemSoundType sound) async {
    soundCalls += 1;
  }
}

void main() {
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

  test('reads settings from storage on initialization', () async {
    final container = ProviderContainer(
      overrides: [
        activePrefsProvider.overrideWithValue(
          SharedPreferencesService(prefs, AppLogger()),
        ),
      ],
    );

    final settings = container.read(appNotificationSettingsProvider);

    expect(settings.appNotifications, isTrue);
    expect(settings.sound, isTrue);
    expect(settings.vibration, isTrue);
    expect(settings.email, isFalse);
    expect(settings.sms, isFalse);
  });

  test('saves and updates state immediately', () async {
    final container = ProviderContainer(
      overrides: [
        activePrefsProvider.overrideWithValue(
          SharedPreferencesService(prefs, AppLogger()),
        ),
      ],
    );

    final notifier = container.read(appNotificationSettingsProvider.notifier);
    await notifier.toggleSound(false);

    expect(container.read(appNotificationSettingsProvider).sound, isFalse);
    verify(() => prefs.setBool('notif_sound', false)).called(1);
  });

  test('sound and vibration are independent toggles', () async {
    final container = ProviderContainer(
      overrides: [
        activePrefsProvider.overrideWithValue(
          SharedPreferencesService(prefs, AppLogger()),
        ),
      ],
    );

    final notifier = container.read(appNotificationSettingsProvider.notifier);
    await notifier.toggleSound(false);
    await notifier.toggleVibration(false);

    final settings = container.read(appNotificationSettingsProvider);
    expect(settings.sound, isFalse);
    expect(settings.vibration, isFalse);
  });

  test('restores previous state when storage write fails', () async {
    final container = ProviderContainer(
      overrides: [
        activePrefsProvider.overrideWithValue(
          SharedPreferencesService(prefs, AppLogger()),
        ),
      ],
    );

    final notifier = container.read(appNotificationSettingsProvider.notifier);
    notifier.state = const NotificationSettings(
      appNotifications: true,
      sound: true,
      vibration: true,
    );

    when(() => prefs.setBool('notif_sound', false)).thenThrow(Exception('boom'));

    await notifier.toggleSound(false);

    expect(container.read(appNotificationSettingsProvider).sound, isTrue);
  });

  test('sound and vibration enabled triggers both effects', () async {
    final platform = _FakeFeedbackPlatform();
    final container = ProviderContainer(
      overrides: [
        activePrefsProvider.overrideWithValue(
          SharedPreferencesService(prefs, AppLogger()),
        ),
      ],
    );

    container.read(appNotificationSettingsProvider.notifier).state =
        const NotificationSettings(appNotifications: true, sound: true, vibration: true);

    final service = FeedbackService(container, platform: platform);
    await service.trigger(FeedbackType.error);

    expect(platform.soundCalls, 1);
    expect(platform.vibrateCalls, 1);
  });

  test('sound disabled keeps vibration active', () async {
    final platform = _FakeFeedbackPlatform();
    final container = ProviderContainer(
      overrides: [
        activePrefsProvider.overrideWithValue(
          SharedPreferencesService(prefs, AppLogger()),
        ),
      ],
    );

    container.read(appNotificationSettingsProvider.notifier).state =
        const NotificationSettings(appNotifications: true, sound: false, vibration: true);

    final service = FeedbackService(container, platform: platform);
    await service.trigger(FeedbackType.error);

    expect(platform.soundCalls, 0);
    expect(platform.vibrateCalls, 1);
  });

  test('vibration disabled keeps sound active', () async {
    final platform = _FakeFeedbackPlatform();
    final container = ProviderContainer(
      overrides: [
        activePrefsProvider.overrideWithValue(
          SharedPreferencesService(prefs, AppLogger()),
        ),
      ],
    );

    container.read(appNotificationSettingsProvider.notifier).state =
        const NotificationSettings(appNotifications: true, sound: true, vibration: false);

    final service = FeedbackService(container, platform: platform);
    await service.trigger(FeedbackType.error);

    expect(platform.soundCalls, 1);
    expect(platform.vibrateCalls, 0);
  });

  test('both feedback channels disabled blocks all effects', () async {
    final platform = _FakeFeedbackPlatform();
    final container = ProviderContainer(
      overrides: [
        activePrefsProvider.overrideWithValue(
          SharedPreferencesService(prefs, AppLogger()),
        ),
      ],
    );

    container.read(appNotificationSettingsProvider.notifier).state =
        const NotificationSettings(appNotifications: true, sound: false, vibration: false);

    final service = FeedbackService(container, platform: platform);
    await service.trigger(FeedbackType.error);

    expect(platform.soundCalls, 0);
    expect(platform.vibrateCalls, 0);
  });

  test('all call sites share the same global feedback policy', () async {
    final platform = _FakeFeedbackPlatform();
    final container = ProviderContainer(
      overrides: [
        activePrefsProvider.overrideWithValue(
          SharedPreferencesService(prefs, AppLogger()),
        ),
      ],
    );

    container.read(appNotificationSettingsProvider.notifier).state =
        const NotificationSettings(appNotifications: true, sound: false, vibration: true);

    final serviceA = FeedbackService(container, platform: platform);
    final serviceB = FeedbackService(container, platform: platform);

    await serviceA.trigger(FeedbackType.error);
    await serviceB.trigger(FeedbackType.securityAlert);

    expect(platform.soundCalls, 0);
    expect(platform.vibrateCalls, 2);
  });
}
