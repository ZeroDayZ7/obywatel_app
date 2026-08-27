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
    final isLoading = asyncState is AsyncLoading;

    return SingleChildScrollView(
      child: Column(
        children: [
          const InfoCard(
            icon: Icons.security,
            titleKey: LocaleKeys.security_setup_additional_security,
            descriptionKey: LocaleKeys.security_setup_pin_or_biometric,
          ),
          const SizedBox(height: 30),

          /// 1. Sekcja "Zaufaj temu urządzeniu"
          _buildTrustDeviceSwitch(context, ref),

          const SizedBox(height: 24),

          /// 2. Animowane opcje PIN / Biometria (tylko przy trustDevice == true)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(sizeFactor: animation, child: child),
              );
            },
            child: state.trustDevice
                ? Column(
                    key: const ValueKey('security_options_visible'),
                    children: [
                      PinTile(
                        pinSet: state.pinSet,
                        onSetup: () => _setupPin(context, ref),
                      ),
                      const SizedBox(height: 16),
                      if (state.biometricAvailable)
                        BiometricTile(
                          enabled: state.biometricSet,
                          onSetup: state.pinSet
                              ? () => ref
                                  .read(securitySetupProvider.notifier)
                                  .enableBiometric()
                              : null,
                        ),
                    ],
                  )
                : const SizedBox.shrink(
                    key: ValueKey('security_options_hidden'),
                  ),
          ),

          const SizedBox(height: 40),

          /// 3. Akcje końcowe (Rejestracja vs Pominięcie)
          if (state.trustDevice) ...[
            AppButton(
              label: LocaleKeys.security_setup_finish_setup.tr(),
              onPressed: state.canFinish && !isLoading
                  ? () async {
                      await ref
                          .read(securitySetupProvider.notifier)
                          .completeSetup();
                    }
                  : null,
              isLoading: isLoading,
              fullWidth: true,
              variant: AppButtonVariant.primary,
            ),
          ] else ...[
            AppButton(
              label: LocaleKeys.security_setup_skip_and_continue.tr(),
              onPressed: !isLoading
                  ? () async {
                      await ref
                          .read(securitySetupProvider.notifier)
                          .skipDeviceRegistration();
                    }
                  : null,
              isLoading: isLoading,
              fullWidth: true,
              variant: AppButtonVariant.secondary,
            ),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildTrustDeviceSwitch(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
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
          ref.read(securitySetupProvider.notifier).toggleTrustDevice(value);
        },
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