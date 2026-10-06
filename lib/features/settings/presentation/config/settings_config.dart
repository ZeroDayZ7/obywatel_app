import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/models/action_item.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/features/settings/domain/settings_section.dart';

class SettingsConfig {
  static List<SettingsSection> getSections(
    BuildContext context,
    WidgetRef ref, {
    required VoidCallback onLanguageTap,
    required VoidCallback onThemeTap,
  }) {
    final securityState = ref.watch(securityServiceProvider);

    return [
      SettingsSection(
        title: LocaleKeys.settings_general.tr(),
        items: [
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
      ),
      SettingsSection(
        title: LocaleKeys.settings_security_title.tr(),
        items: [
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
            subtitle: securityState.canUseBiometrics
                ? LocaleKeys.settings_biometrics_subtitle.tr()
                : LocaleKeys.settings_notifications_settings_not_available.tr(),
            type: ActionType.toggle,
            initialValue: securityState.isBiometricEnabled,
            onToggle: securityState.canUseBiometrics
                ? (value) => ref
                    .read(securityServiceProvider.notifier)
                    .toggleBiometrics(value)
                : null,
            isEnabled: securityState.canUseBiometrics,
          ),
        ],
      ),
    ];
  }
}