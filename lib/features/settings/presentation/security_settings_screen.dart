import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/margins/screen_margins.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';
import 'package:obywatel_plus/features/settings/presentation/widgets/emergency_lock_dialog.dart';

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
      body: ListView(
        padding: ScreenMargins.all,
        children: [
          _Section(
            title: LocaleKeys.settings_security_pin_section.tr(),
            children: [
              Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.lock_person_outlined,
                        color: securityState.isPinConfigured
                            ? Colors.green
                            : Colors.grey,
                      ),
                      title: Text(
                        LocaleKeys.settings_security_pin.tr(),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        securityState.isPinConfigured
                            ? LocaleKeys.settings_security_pin_enabled.tr()
                            : LocaleKeys.settings_security_pin_disabled.tr(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    // Zastąp TextButton tym kodem:
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          AppButton(
                            labelKey: LocaleKeys.settings_common_change_pin,
                            variant: AppButtonVariant.text,
                            onPressed: () => context.push(
                              '${AppRoutes.settings}/${AppRoutes.settingsChangePin}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // SEKCJA BIOMETRII - Przełącznik (Switch)
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
                        ? LocaleKeys.settings_security_biometrics_subtitle.tr()
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

          // SEKCJA DOSTĘPU (SESJE I BLOKADA)
          _Section(
            title: LocaleKeys.settings_security_access_section.tr(),
            children: [
              _ActionTile(
                icon: Icons.devices,
                title: LocaleKeys.settings_security_active_sessions.tr(),
                onTap: () => context.push(
                  '${AppRoutes.settings}/${AppRoutes.settingsActiveSession}',
                ),
              ),
              _ActionTile(
                icon: Icons.lock_reset,
                title: LocaleKeys.settings_security_emergency_lock.tr(),
                onTap: () => EmergencyLockDialog.show(context, ref),
                isDanger: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// =====================
/// SEKCJE I KAFELKI (Wewnętrzne)
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

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDanger;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDanger
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).iconTheme.color;

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: isDanger ? TextStyle(color: color) : null),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
