import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/utils/device_capabilities.dart';
import 'package:obywatel_plus/features/settings/domain/notification_settings_notifier.dart';

class NotificationsSettingsScreen extends ConsumerWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Słuchamy stanu możliwości urządzenia (async)
    final capsAsync = ref.watch(deviceCapabilitiesProvider);
    // Słuchamy aktualnego stanu ustawień (przebuduje UI przy zmianie switcha)
    final settings = ref.watch(notificationSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.settings_notifications_settings_title.tr()),
        centerTitle: true,
      ),
      body: capsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(LocaleKeys.errors_general.tr())),
        data: (caps) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: Text(
                LocaleKeys.settings_notifications_settings_app_notifications
                    .tr(),
              ),
              value: settings.appNotifications,
              onChanged: (val) => ref
                  .read(notificationSettingsProvider.notifier)
                  .toggleApp(val),
            ),
            SwitchListTile(
              title: Text(
                LocaleKeys.settings_notifications_settings_sound.tr(),
              ),
              value: settings.sound,
              onChanged: (val) => ref
                  .read(notificationSettingsProvider.notifier)
                  .toggleSound(val),
            ),
            SwitchListTile(
              title: Text(
                LocaleKeys.settings_notifications_settings_vibration.tr(),
                style: caps.hasVibration
                    ? null
                    : const TextStyle(color: Colors.grey),
              ),
              value: caps.hasVibration && settings.vibration,
              onChanged: caps.hasVibration
                  ? (val) => ref
                        .read(notificationSettingsProvider.notifier)
                        .toggleVibration(val)
                  : null,
              subtitle: !caps.hasVibration
                  ? Text(
                      LocaleKeys.settings_notifications_settings_not_available
                          .tr(),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    )
                  : null,
            ),
            const Divider(),
            SwitchListTile(
              title: Text(
                LocaleKeys.settings_notifications_settings_email.tr(),
              ),
              value: settings.email,
              onChanged: (val) => ref
                  .read(notificationSettingsProvider.notifier)
                  .toggleEmail(val),
            ),
            SwitchListTile(
              title: Text(LocaleKeys.settings_notifications_settings_sms.tr()),
              value: settings.sms,
              onChanged: (val) => ref
                  .read(notificationSettingsProvider.notifier)
                  .toggleSms(val),
            ),
          ],
        ),
      ),
    );
  }
}
