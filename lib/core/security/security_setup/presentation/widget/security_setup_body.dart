import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/theme/theme_extensions.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';
import 'package:obywatel_plus/core/security/security_setup/presentation/widget/pin_setup_dialog.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_notifier.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_state.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/settings/presentation/widgets/biometric_tile.dart';
import 'package:obywatel_plus/features/settings/presentation/widgets/info_card.dart';

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

          /// 2. Wybór metody lokalnego zabezpieczenia (PIN | Hasło)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: state.trustDevice
                ? Column(
                    key: const ValueKey('security_method_selection'),
                    children: [
                      _buildMethodCard(
                        context,
                        title: 'PIN',
                        subtitle: 'Numeryczny kod lokalnego odblokowania',
                        selected: state.localSecurityMethod == LocalSecurityMethod.pin,
                        onTap: () => ref
                            .read(securitySetupProvider.notifier)
                            .selectLocalSecurityMethod(LocalSecurityMethod.pin),
                      ),
                      const SizedBox(height: 12),
                      _buildMethodCard(
                        context,
                        title: 'Hasło',
                        subtitle: 'Hasło lokalnego odblokowania',
                        selected:
                            state.localSecurityMethod == LocalSecurityMethod.password,
                        onTap: () => ref
                            .read(securitySetupProvider.notifier)
                            .selectLocalSecurityMethod(
                              LocalSecurityMethod.password,
                            ),
                      ),
                      const SizedBox(height: 16),
                      if (state.localSecurityMethod != LocalSecurityMethod.none)
                        AppButton(
                          label: state.isPinMethod
                              ? 'Ustaw PIN'
                              : 'Ustaw hasło',
                          onPressed: () => _setupLocalSecret(context, ref),
                          fullWidth: true,
                          variant: AppButtonVariant.secondary,
                        ),
                      const SizedBox(height: 16),
                      if (state.secretConfigured)
                        Text(
                          state.isPinMethod
                              ? 'PIN został poprawnie zweryfikowany.'
                              : 'Hasło zostało poprawnie zweryfikowane.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  )
                : const SizedBox.shrink(
                    key: ValueKey('security_options_hidden'),
                  ),
          ),

          const SizedBox(height: 24),

          /// 3. Animowane opcje PIN / Biometria
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
                      if (state.biometricAvailable)
                        BiometricTile(
                          enabled: state.biometricSet,
                          onSetup: state.secretConfigured
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
                          .read(authControllerProvider.notifier)
                          .createTemporarySession();
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

    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip
          .antiAlias, // Zapewnia ładne przycinanie efektu kliknięcia do zaokrąglonych rogów
      child: Container(
        decoration: BoxDecoration(
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
      ),
    );
  }

  Widget _buildMethodCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: selected
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.2)
          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    width: 2,
                  ),
                  color: selected ? theme.colorScheme.primary : Colors.transparent,
                ),
                child: selected
                    ? Icon(
                        Icons.check,
                        size: 18,
                        color: theme.colorScheme.onPrimary,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _setupLocalSecret(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(securitySetupProvider.notifier);
    final method = state.localSecurityMethod;

    final secret = await showDialog<String>(
      context: context,
      builder: (_) => PinSetupDialog(method: method),
      barrierColor: context.colorScheme.scrim.withValues(alpha: 0.7),
    );

    if (secret == null || secret.isEmpty) return;

    final values = secret.split('\n');
    final value = values.first;
    final confirmation = values.length > 1 ? values[1] : value;

    await notifier.setLocalSecret(
      method: method,
      value: value,
      confirmation: confirmation,
    );
  }
}
