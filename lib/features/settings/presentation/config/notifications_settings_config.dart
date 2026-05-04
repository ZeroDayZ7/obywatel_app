import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/models/action_item.dart';
import 'package:obywatel_plus/core/utils/device_capabilities_state.dart';
import 'package:obywatel_plus/features/settings/domain/notification_settings_notifier.dart';
import 'package:obywatel_plus/features/settings/domain/notification_settings_state.dart';

class NotificationsSettingsConfig {
  static List<Map<String, dynamic>> getSections({
    required DeviceCapabilitiesState caps,
    required NotificationSettings settings,
    required NotificationSettingsNotifier notifier,
  }) {
    return [
      {
        'title': 'Ogólne powiadomienia',
        'items': [
          ActionItem(
            icon: Icons.notifications,
            title: LocaleKeys.settings_notifications_settings_app_notifications
                .tr(),
            type: ActionType.toggle,
            initialValue: settings.appNotifications,
            onToggle: notifier.toggleApp,
          ),
          ActionItem(
            icon: Icons.volume_up,
            title: LocaleKeys.settings_notifications_settings_sound.tr(),
            type: ActionType.toggle,
            initialValue: settings.sound,
            onToggle: notifier.toggleSound,
          ),
          ActionItem(
            icon: Icons.vibration,
            title: LocaleKeys.settings_notifications_settings_vibration.tr(),
            subtitle: !caps.hasVibration
                ? LocaleKeys.settings_notifications_settings_not_available.tr()
                : null,
            type: ActionType.toggle,
            initialValue: caps.hasVibration && settings.vibration,
            onToggle: notifier.toggleVibration,
            isEnabled: caps.hasVibration,
          ),
        ],
      },
      {
        'title': 'Kanały powiadomień',
        'items': [
          ActionItem(
            icon: Icons.email,
            title: LocaleKeys.settings_notifications_settings_email.tr(),
            type: ActionType.toggle,
            initialValue: settings.email,
            onToggle: notifier.toggleEmail,
          ),
          ActionItem(
            icon: Icons.sms,
            title: LocaleKeys.settings_notifications_settings_sms.tr(),
            type: ActionType.toggle,
            initialValue: settings.sms,
            onToggle: notifier.toggleSms,
          ),
        ],
      },
    ];
  }
}
