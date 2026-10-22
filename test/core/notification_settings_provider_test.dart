import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/notifications/notification_settings.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

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
    notifier.toggleSound(false);

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
    notifier.toggleSound(false);
    notifier.toggleVibration(false);

    final settings = container.read(appNotificationSettingsProvider);
    expect(settings.sound, isFalse);
    expect(settings.vibration, isFalse);
  });

  test('restores previous state when storage write fails', () async {
    when(() => prefs.setBool('notif_sound', false)).thenThrow(Exception('boom'));

    final container = ProviderContainer(
      overrides: [
        activePrefsProvider.overrideWithValue(
          SharedPreferencesService(prefs, AppLogger()),
        ),
      ],
    );

    final notifier = container.read(appNotificationSettingsProvider.notifier);
    notifier.toggleSound(false);

    expect(container.read(appNotificationSettingsProvider).sound, isTrue);
  });
}
