import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_notifier.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_state.dart';
import 'package:obywatel_plus/core/widgets/ui/button.dart';
import 'package:obywatel_plus/features/settings/presentation/widgets/biometric_tile.dart';
import 'package:obywatel_plus/features/settings/presentation/widgets/info_card.dart';
import 'package:obywatel_plus/features/settings/presentation/widgets/pin_setup_dialog.dart';
import 'package:obywatel_plus/features/settings/presentation/widgets/pin_tile.dart';

class SecuritySetupBody extends ConsumerWidget {
  final SecuritySetupState state;

  const SecuritySetupBody({super.key, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(securitySetupProvider);
    return SingleChildScrollView(
      child: Column(
        children: [
          const InfoCard(
            icon: Icons.security,
            titleKey: LocaleKeys.security_setup_additional_security,
            descriptionKey: LocaleKeys.security_setup_pin_or_biometric,
          ),
          const SizedBox(height: 30),

          PinTile(pinSet: state.pinSet, onSetup: () => _setupPin(context, ref)),

          const SizedBox(height: 20),

          if (state.biometricAvailable)
            BiometricTile(
              enabled: state.biometricSet,
              onSetup: state.pinSet
                  ? () => ref
                        .read(securitySetupProvider.notifier)
                        .enableBiometric()
                  : null,
            ),

          const SizedBox(height: 40),

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
            fullWidth: false,
            variant: AppButtonVariant.primary,
          ),

          const SizedBox(height: 20),

          AppButton(
            labelKey: LocaleKeys.common_skip,
            variant: AppButtonVariant.textDanger,
            onPressed: () {
              ref.read(securitySetupProvider.notifier).skipSetup();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _setupPin(BuildContext context, WidgetRef ref) async {
    final pin = await showDialog<String>(
      context: context,
      builder: (_) =>
          const Dialog(child: SingleChildScrollView(child: PinSetupDialog())),
    );

    if (pin == null || pin.isEmpty) return;

    ref.read(securitySetupProvider.notifier).setPin(pin);
  }
}
