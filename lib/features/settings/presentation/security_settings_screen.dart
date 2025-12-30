import 'package:action_slider/action_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/margins/screen_margins.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';
import 'package:obywatel_plus/core/security/security/security_service_provider.dart';

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
          // SEKCJA PIN - Informacja o statusie i przycisk zmiany
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton.icon(
                              onPressed: () => context.push(AppRoutes.setPin),
                              icon: const Icon(Icons.edit_note, size: 20),
                              label: Text(
                                LocaleKeys.settings_common_change_pin.tr(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft,
                              ),
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
                onTap: () => _showEmergencyLockDialog(context, ref),
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

// Metoda wyświetlająca dialog z suwakiem
void _showEmergencyLockDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) {
      // Pobieramy szerokość ekranu, żeby dialog był responsywny
      final screenWidth = MediaQuery.of(context).size.width;
      // Obliczamy szerokość: albo 400px, albo prawie cały ekran na telefonie
      final dialogWidth = screenWidth > 500 ? 400.0 : screenWidth * 0.85;

      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 28,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                LocaleKeys.settings_security_emergency_lock.tr(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        // Kluczowa zmiana: Container ze sztywnym 'width' zamiast ConstrainedBox
        content: SizedBox(
          width: dialogWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                LocaleKeys.settings_security_emergency_lock_description.tr(),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),
              ActionSlider.standard(
                sliderBehavior: SliderBehavior.move,
                width: dialogWidth,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest,
                toggleColor: Colors.red,
                actionThresholdType: ThresholdType.release,
                icon: const Icon(Icons.lock_reset, color: Colors.white),
                action: (controller) async {
                  controller.loading();
                  await Future.delayed(const Duration(seconds: 2));
                  await ref.read(securityServiceProvider.notifier).lockApp();

                  // if (context.mounted) {
                  //   controller.success();
                  //   await Future.delayed(const Duration(milliseconds: 500));
                  //   Navigator.of(context).pop();
                  //   context.go(AppRoutes.login);
                  // }
                },
                child: Text(
                  LocaleKeys.settings_security_emergency_lock_slider.tr(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          AppButton(
            labelKey: LocaleKeys.common_cancel,
            variant: AppButtonVariant.text,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    },
  );
}
