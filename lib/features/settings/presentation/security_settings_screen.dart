import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/widgets/responsive_content_wrapper.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/features/settings/presentation/widgets/emergency_lock_dialog.dart';
import 'package:obywatel_plus/features/settings/presentation/widgets/settings_card.dart';

class SecuritySettingsScreen extends ConsumerWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final securityState = ref.watch(securityServiceProvider);
    final securityNotifier = ref.read(securityServiceProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.settings_security_title.tr()),
        centerTitle: true,
      ),
      body: ResponsiveContainer(
        child: ListView(
          children: [
            _Section(
              title: LocaleKeys.settings_security_pin_section.tr(),
              children: [
                SettingsCard(
                  icon: Icons.lock_person_outlined,
                  title: LocaleKeys.settings_security_pin.tr(),
                  subtitle: securityState.isPinConfigured
                      ? LocaleKeys.settings_security_pin_enabled.tr()
                      : LocaleKeys.settings_security_pin_disabled.tr(),
                  showArrow: true,
                  onTap: () => context.push(
                    '${AppRoutes.settings}/${AppRoutes.settingsChangePin}',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _Section(
              title: LocaleKeys.settings_security_biometrics.tr(),
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  child: SwitchListTile(
                    secondary: Icon(
                      Icons.fingerprint,
                      color: securityState.canUseBiometrics
                          ? Colors.blueAccent
                          : Colors.grey,
                    ),
                    title: Text(
                      LocaleKeys.settings_security_biometrics.tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: securityState.canUseBiometrics
                            ? null
                            : Colors.grey,
                      ),
                    ),
                    subtitle: Text(
                      securityState.canUseBiometrics
                          ? LocaleKeys.settings_security_biometrics_subtitle
                                .tr()
                          : LocaleKeys
                                .settings_notifications_settings_not_available
                                .tr(),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    value: securityState.isBiometricEnabled,
                    onChanged: securityState.canUseBiometrics
                        ? (val) => securityNotifier.toggleBiometrics(val)
                        : null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            _Section(
              title: LocaleKeys.settings_security_access_section.tr(),
              children: [
                SettingsCard(
                  icon: Icons.devices,
                  title: LocaleKeys.settings_security_active_sessions.tr(),
                  showArrow: true,
                  subtitle: '',
                  onTap: () => context.push(
                    '${AppRoutes.settings}/${AppRoutes.settingsActiveSession}',
                  ),
                ),
                SettingsCard(
                  icon: Icons.lock_reset,
                  title: LocaleKeys.settings_security_emergency_lock.tr(),
                  showArrow: false,
                  subtitle: '',
                  onTap: () => EmergencyLockDialog.show(context, ref),
                  isDanger: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// =====================
/// SEKCJE (tylko nagłówki)
/// =====================

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}
