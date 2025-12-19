import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/widgets/ui/button.dart';
import 'package:obywatel_plus/core/widgets/ui/switch.dart';

/// ====================
/// PROVIDERY DO TESTÓW
/// ====================

final pinEnabledProvider = Provider<bool>((ref) {
  // 🔧 Do testów: zmień na false, żeby zobaczyć drugą gałąź (Set PIN)
  return true;
});

final biometricsEnabledProvider = Provider<bool>((ref) {
  // 🔧 Do testów: możesz zmieniać
  return false;
});

/// ====================
/// EKRAN USTAWIEŃ BEZPIECZEŃSTWA
/// ====================

class SecuritySettingsScreen extends ConsumerWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinEnabled = ref.watch(pinEnabledProvider);
    final biometricsEnabled = ref.watch(biometricsEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.settings_security.tr()),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(
            title: LocaleKeys.settings_security_pin_section.tr(),
            children: [
              _PinStatusTile(enabled: pinEnabled),
              const SizedBox(height: 12),
              AppButton(
                labelKey: pinEnabled
                    ? LocaleKeys.settings_common_change_pin
                    : LocaleKeys.settings_common_set_pin,
                onPressed: () {
                  context.push(AppRoutes.setPin);
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          AppSwitch(
            icon: Icons.fingerprint,
            title: LocaleKeys.settings_security_biometrics.tr(),
            subtitle: LocaleKeys.settings_security_biometrics_subtitle.tr(),
            value: biometricsEnabled,
            onChanged: (val) {
              // zmiana stanu providerem
            },
          ),

          const SizedBox(height: 24),

          _Section(
            title: LocaleKeys.settings_security_access_section.tr(),
            children: [
              _ActionTile(
                icon: Icons.devices,
                title: LocaleKeys.settings_security_active_sessions.tr(),
                onTap: () {
                  // context.push(AppRoutes.securitySessions);
                },
              ),
              _ActionTile(
                icon: Icons.lock_reset,
                title: LocaleKeys.settings_security_emergency_lock.tr(),
                onTap: () {
                  // ignore: todo
                  // TODO: pokaż dialog / bottom sheet
                },
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
/// SEKCJE I KAFELKI
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

class _PinStatusTile extends StatelessWidget {
  final bool enabled;

  const _PinStatusTile({required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.pin, color: enabled ? Colors.green : Colors.grey),
        title: Text(LocaleKeys.settings_security_pin.tr()),
        subtitle: Text(
          enabled
              ? LocaleKeys.settings_security_pin_enabled.tr()
              : LocaleKeys.settings_security_pin_disabled.tr(),
        ),
      ),
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
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title, style: isDanger ? TextStyle(color: color) : null),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
