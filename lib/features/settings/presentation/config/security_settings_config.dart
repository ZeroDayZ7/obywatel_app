import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/models/action_item.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/core/security/security/security_state.dart';
import 'package:obywatel_plus/features/settings/presentation/widgets/emergency_lock_dialog.dart';

class SecuritySettingsConfig {
  static List<Map<String, dynamic>> getSections(
    BuildContext context,
    WidgetRef ref, {
    required SecurityState state,
    required SecurityService notifier,
  }) {
    return [
      {
        'title': LocaleKeys.settings_security_pin_section.tr(),
        'items': [
          ActionItem(
            icon: Icons.lock_person_outlined,
            title: LocaleKeys.settings_security_pin.tr(),
            subtitle: state.isPinConfigured
                ? LocaleKeys.settings_security_pin_enabled.tr()
                : LocaleKeys.settings_security_pin_disabled.tr(),
            type: ActionType.navigation,
            onTap: () => context.push(
              '${AppRoutes.settings}/${AppRoutes.settingsChangePin}',
            ),
          ),
        ],
      },
      {
        'title': LocaleKeys.settings_security_biometrics.tr(),
        'items': [
          ActionItem(
            icon: Icons.fingerprint,
            title: LocaleKeys.settings_security_biometrics.tr(),
            subtitle: state.canUseBiometrics
                ? LocaleKeys.settings_security_biometrics_subtitle.tr()
                : LocaleKeys.settings_notifications_settings_not_available.tr(),
            type: ActionType.toggle,
            initialValue: state.isBiometricEnabled,
            onToggle: notifier.toggleBiometrics,
            isEnabled: state.canUseBiometrics,
          ),
        ],
      },
      {
        'title': LocaleKeys.settings_security_access_section.tr(),
        'items': [
          ActionItem(
            icon: Icons.devices,
            title: LocaleKeys.settings_security_active_sessions.tr(),
            type: ActionType.navigation,
            onTap: () => context.push(
              '${AppRoutes.settings}/${AppRoutes.settingsActiveSession}',
            ),
          ),
          ActionItem(
            icon: Icons.lock_reset,
            title: LocaleKeys.settings_security_emergency_lock.tr(),
            type: ActionType.navigation,
            onTap: () => EmergencyLockDialog.show(context, ref),
            isDanger: true,
          ),
        ],
      },
    ];
  }
}
