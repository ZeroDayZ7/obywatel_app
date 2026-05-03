import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';
import 'package:obywatel_plus/core/utils/device_capabilities_provider.dart';
import 'package:obywatel_plus/features/settings/domain/notification_settings_notifier.dart';

class NotificationsSettingsScreen extends ConsumerWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Odczytujemy stan synchronicznie (Notifier, nie FutureProvider)
    final caps = ref.watch(deviceCapabilitiesProvider);
    final settings = ref.watch(notificationSettingsProvider);
    final settingsNotifier = ref.read(notificationSettingsProvider.notifier);

    return AppScaffold(
      title: Text(LocaleKeys.settings_notifications_settings_title.tr()),
      size: ContainerSize.medium,
      // Jeśli caps nie są jeszcze zainicjalizowane, pokazujemy loader
      child: !caps.initialized
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionCard(context, [
                  _buildSwitch(
                    title: LocaleKeys
                        .settings_notifications_settings_app_notifications
                        .tr(),
                    value: settings.appNotifications,
                    onChanged: settingsNotifier.toggleApp,
                  ),
                  _buildSwitch(
                    title: LocaleKeys.settings_notifications_settings_sound
                        .tr(),
                    value: settings.sound,
                    onChanged: settingsNotifier.toggleSound,
                  ),
                  _buildSwitch(
                    title: LocaleKeys.settings_notifications_settings_vibration
                        .tr(),
                    // Wartość wymuszona na false, jeśli urządzenie nie ma wibracji
                    value: caps.hasVibration && settings.vibration,
                    // Deaktywujemy switch, jeśli brak wsparcia sprzętowego
                    onChanged: caps.hasVibration
                        ? settingsNotifier.toggleVibration
                        : null,
                    subtitle: !caps.hasVibration
                        ? LocaleKeys
                              .settings_notifications_settings_not_available
                              .tr()
                        : null,
                    isEnabled: caps.hasVibration,
                  ),
                ]),
                const SizedBox(height: 24),
                _buildSectionCard(context, [
                  _buildSwitch(
                    title: LocaleKeys.settings_notifications_settings_email
                        .tr(),
                    value: settings.email,
                    onChanged: settingsNotifier.toggleEmail,
                  ),
                  _buildSwitch(
                    title: LocaleKeys.settings_notifications_settings_sms.tr(),
                    value: settings.sms,
                    onChanged: settingsNotifier.toggleSms,
                  ),
                ]),
              ],
            ),
    );
  }

  /// Pomocniczy widget dla powtarzalnych Switchy
  Widget _buildSwitch({
    required String title,
    required bool value,
    required ValueChanged<bool>? onChanged,
    String? subtitle,
    bool isEnabled = true,
  }) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isEnabled ? null : Colors.grey,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            )
          : null,
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSectionCard(BuildContext context, List<Widget> children) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: Column(children: children),
    );
  }
}
