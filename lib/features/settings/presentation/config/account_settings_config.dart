import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/models/action_item.dart';
import 'package:obywatel_plus/features/settings/domain/settings_section.dart';

class AccountSettingsConfig {
  static List<SettingsSection> getSections(
    BuildContext context,
    WidgetRef ref,
  ) {
    return [
      SettingsSection(
        title: LocaleKeys.settings_account_title.tr(),
        items: [
          ActionItem(
            icon: Icons.lock_reset_rounded,
            title: LocaleKeys.settings_account_change_password.tr(),
            subtitle: LocaleKeys.settings_account_change_password_subtitle.tr(),
            type: ActionType.navigation,
            onTap: () => context.push(
              '${AppRoutes.settings}/${AppRoutes.settingsChangePassword}',
            ),
          ),
          ActionItem(
            icon: Icons.email_outlined,
            title: LocaleKeys.settings_account_change_email.tr(),
            subtitle: LocaleKeys.settings_account_future_feature.tr(),
            type: ActionType.navigation,
            isEnabled: false,
          ),
          ActionItem(
            icon: Icons.security_rounded,
            title: LocaleKeys.settings_account_two_factor.tr(),
            subtitle: LocaleKeys.settings_account_future_feature.tr(),
            type: ActionType.navigation,
            isEnabled: false,
          ),
          ActionItem(
            icon: Icons.devices_other_outlined,
            title: LocaleKeys.settings_account_active_sessions.tr(),
            subtitle: LocaleKeys.settings_account_active_sessions_subtitle.tr(),
            type: ActionType.navigation,
            onTap: () => context.push(
              '${AppRoutes.settings}/${AppRoutes.settingsActiveSession}',
            ),
          ),
          ActionItem(
            icon: Icons.restore_rounded,
            title: LocaleKeys.settings_account_recovery.tr(),
            subtitle: LocaleKeys.settings_account_future_feature.tr(),
            type: ActionType.navigation,
            isEnabled: false,
          ),
        ],
      ),
    ];
  }
}
