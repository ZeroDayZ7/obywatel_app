import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';
import 'package:obywatel_plus/core/security/security_setup/presentation/widget/pin_setup_dialog.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_notifier.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_state.dart';
import 'package:obywatel_plus/features/settings/presentation/widgets/biometric_tile.dart';
import 'package:obywatel_plus/features/settings/presentation/widgets/info_card.dart';
import 'package:obywatel_plus/features/settings/presentation/widgets/pin_tile.dart';

class SecuritySetupBody extends ConsumerWidget {
  final SecuritySetupState state;

  const SecuritySetupBody({super.key, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(securitySetupProvider);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          const InfoCard(
            icon: Icons.security,
            titleKey: LocaleKeys.security_setup_additional_security,
            descriptionKey: LocaleKeys.security_setup_pin_or_biometric,
          ),
          const SizedBox(height: 30),

          // Kafelek PIN
          PinTile(pinSet: state.pinSet, onSetup: () => _setupPin(context, ref)),

          const SizedBox(height: 16),

          // Kafelek Biometrii (widoczny tylko jeśli urządzenie wspiera)
          if (state.biometricAvailable)
            BiometricTile(
              enabled: state.biometricSet,
              onSetup: state.pinSet
                  ? () => ref
                        .read(securitySetupProvider.notifier)
                        .enableBiometric()
                  : null,
            ),

          const SizedBox(height: 32),

          // Sekcja "Zaufaj temu urządzeniu" (Trust Device Switch)
          // Serwer nie wie kim jesteś, ale dzięki temu nie zapyta o 2FA
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.3,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: state.trustDevice
                    ? theme.colorScheme.primary.withValues(alpha: 0.5)
                    : Colors.transparent,
              ),
            ),
            child: SwitchListTile(
              secondary: Icon(
                state.trustDevice
                    ? Icons.verified_user
                    : Icons.enhanced_encryption_outlined,
                color: state.trustDevice ? theme.colorScheme.primary : null,
              ),
              title: Text(
                LocaleKeys.security_setup_trust_device_title.tr(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                LocaleKeys.security_setup_trust_device_desc.tr(),
                style: theme.textTheme.bodySmall,
              ),
              value: state.trustDevice,
              onChanged: (value) {
                ref
                    .read(securitySetupProvider.notifier)
                    .toggleTrustDevice(value);
              },
            ),
          ),

          const SizedBox(height: 40),

          // Przycisk kończący - brak przycisku SKIP (wymagane bezpieczeństwo)
          AppButton(
            labelKey: LocaleKeys.security_setup_finish_setup,
            onPressed: state.canFinish && asyncState is! AsyncLoading
                ? () async {
                    await ref
                        .read(securitySetupProvider.notifier)
                        .completeSetup();
                  }
                : null,
            isLoading: asyncState is AsyncLoading,
            fullWidth: true,
            variant: AppButtonVariant.primary,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _setupPin(BuildContext context, WidgetRef ref) async {
    final pin = await showDialog<String>(
      context: context,
      builder: (_) => const PinSetupDialog(),
      barrierColor: Colors.black.withValues(alpha: 0.7),
    );

    if (pin == null || pin.isEmpty) return;

    ref.read(securitySetupProvider.notifier).setPin(pin);
  }
}
