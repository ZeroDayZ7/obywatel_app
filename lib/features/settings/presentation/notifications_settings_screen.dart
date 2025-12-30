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
    final capsAsync = ref.watch(deviceCapabilitiesProvider);

    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.settings_notifications_settings_title.tr()),
        centerTitle: true,
      ),
      body: capsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Center(child: Text("Błąd ładowania")),
        data: (caps) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: Text(
                LocaleKeys.settings_notifications_settings_app_notifications
                    .tr(),
              ),
              value: settings.appNotifications,
              onChanged: notifier.toggleApp,
            ),
            SwitchListTile(
              title: Text(
                LocaleKeys.settings_notifications_settings_sound.tr(),
              ),
              value: settings.sound,
              onChanged: notifier.toggleSound,
            ),
            SwitchListTile(
              title: Text(
                LocaleKeys.settings_notifications_settings_vibration.tr(),
                style: caps.hasVibration
                    ? null
                    : const TextStyle(color: Colors.grey),
              ),
              // Jeśli urządzenie nie ma wibracji, switch jest wyłączony i nieaktywny
              value: caps.hasVibration && settings.vibration,
              onChanged: caps.hasVibration ? notifier.toggleVibration : null,
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
              onChanged: notifier.toggleEmail,
            ),
            SwitchListTile(
              title: Text(LocaleKeys.settings_notifications_settings_sms.tr()),
              value: settings.sms,
              onChanged: notifier.toggleSms,
            ),
          ],
        ),
      ),
    );
  }
}
