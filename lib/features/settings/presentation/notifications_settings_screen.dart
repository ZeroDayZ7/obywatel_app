import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';
import 'package:obywatel_plus/core/utils/device_capabilities.dart';
import 'package:obywatel_plus/features/settings/domain/notification_settings_notifier.dart';

class NotificationsSettingsScreen extends ConsumerWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final capsAsync = ref.watch(deviceCapabilitiesProvider);
    final settings = ref.watch(notificationSettingsProvider);

    return AppScaffold(
      title: Text(LocaleKeys.settings_notifications_settings_title.tr()),
      size: ContainerSize.medium,
      scrollable: true,
      child: capsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(LocaleKeys.errors_general.tr())),
        data: (caps) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionCard([
              SwitchListTile(
                title: Text(
                  LocaleKeys.settings_notifications_settings_app_notifications
                      .tr(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                value: settings.appNotifications,
                onChanged: (val) => ref
                    .read(notificationSettingsProvider.notifier)
                    .toggleApp(val),
              ),
              SwitchListTile(
                title: Text(
                  LocaleKeys.settings_notifications_settings_sound.tr(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                value: settings.sound,
                onChanged: (val) => ref
                    .read(notificationSettingsProvider.notifier)
                    .toggleSound(val),
              ),
              SwitchListTile(
                title: Text(
                  LocaleKeys.settings_notifications_settings_vibration.tr(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: caps.hasVibration ? null : Colors.grey,
                  ),
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
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      )
                    : null,
              ),
            ]),
            const SizedBox(height: 24),
            _buildSectionCard([
              SwitchListTile(
                title: Text(
                  LocaleKeys.settings_notifications_settings_email.tr(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                value: settings.email,
                onChanged: (val) => ref
                    .read(notificationSettingsProvider.notifier)
                    .toggleEmail(val),
              ),
              SwitchListTile(
                title: Text(
                  LocaleKeys.settings_notifications_settings_sms.tr(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                value: settings.sms,
                onChanged: (val) => ref
                    .read(notificationSettingsProvider.notifier)
                    .toggleSms(val),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Builder(
      builder: (context) {
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
      },
    );
  }
}
