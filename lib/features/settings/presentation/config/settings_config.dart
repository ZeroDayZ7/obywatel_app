import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/models/action_item.dart';

class SettingsConfig {
  static List<Map<String, dynamic>> getSections(
    BuildContext context, {
    required VoidCallback onLanguageTap,
    required VoidCallback onThemeTap,
    required Function(bool) onBiometryToggle,
    bool biometryValue = false,
    bool isBiometryAvailable = false,
  }) {
    return [
      {
        'title': LocaleKeys.settings_general.tr(),
        'items': [
          ActionItem(
            icon: Icons.notifications,
            title: LocaleKeys.settings_notifications.tr(),
            subtitle: LocaleKeys.settings_notifications_subtitle.tr(),
            type: ActionType.navigation,
            onTap: () => context.push(
              '${AppRoutes.settings}/${AppRoutes.settingsNotifications}',
            ),
          ),
          ActionItem(
            icon: Icons.language,
            title: LocaleKeys.settings_language.tr(),
            subtitle: LocaleKeys.settings_language_subtitle.tr(),
            type: ActionType.sheet,
            onTap: onLanguageTap,
          ),
          ActionItem(
            icon: Icons.palette,
            title: LocaleKeys.settings_theme.tr(),
            subtitle: LocaleKeys.settings_theme_subtitle.tr(),
            type: ActionType.sheet,
            onTap: onThemeTap,
          ),
        ],
      },
      {
        'title': LocaleKeys.settings_security_title.tr(),
        'items': [
          ActionItem(
            icon: Icons.security,
            title: LocaleKeys.settings_security_title.tr(),
            subtitle: LocaleKeys.settings_security_subtitle.tr(),
            type: ActionType.navigation,
            onTap: () => context.push(
              '${AppRoutes.settings}/${AppRoutes.settingsSecurity}',
            ),
          ),
          ActionItem(
            icon: Icons.fingerprint,
            title: LocaleKeys.settings_biometrics.tr(),
            subtitle: LocaleKeys.settings_biometrics_subtitle.tr(),
            type: ActionType.toggle,
            initialValue: biometryValue,
            onToggle: onBiometryToggle,
            isEnabled: isBiometryAvailable,
          ),
        ],
      },
    ];
  }
}
