import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/core_providers.dart'; // appLoggerProvider
import 'package:obywatel_plus/core/security/security_setup_provider.dart';
import 'package:obywatel_plus/core/widgets/buttons/button.dart';

import '../../../features/settings/presentation/widgets/biometric_tile.dart';
import '../../../features/settings/presentation/widgets/info_card.dart';
import '../../../features/settings/presentation/widgets/pin_setup_dialog.dart';
import '../../../features/settings/presentation/widgets/pin_tile.dart';

class SecuritySetupScreen extends ConsumerWidget {
  const SecuritySetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setupAsync = ref.watch(securitySetupProvider);
    final logger = ref.read(
      appLoggerProvider,
    ); // Sync read, zakładam Provider<AppLogger>

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Ustawienia bezpieczeństwa')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: setupAsync.when(
          data: (setupState) => _buildBody(context, ref, setupState, logger),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, st) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Błąd: $error'),
                ElevatedButton(
                  onPressed: () => ref.invalidate(securitySetupProvider),
                  child: const Text('Spróbuj ponownie'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    SetupState state,
    dynamic logger,
  ) {
    // dynamic jeśli AppLogger nie zdefiniowany – dostosuj
    ref.listen(securitySetupProvider, (prev, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Błąd: ${next.error}')));
      }
    });

    // Async wrappers dla sync callbacks
    void onSetupPin() async {
      final result = await showDialog<String>(
        context: context,
        builder: (_) =>
            const Dialog(child: SingleChildScrollView(child: PinSetupDialog())),
      );
      if (result == null || result.isEmpty) return;
      try {
        await ref.read(securitySetupProvider.notifier).setPin(result);
        logger.i('PIN ustawiony w UI');
      } catch (e) {
        logger.e('Błąd PIN w UI', error: e);
      }
    }

    void onSetupBiometric() async {
      try {
        await ref.read(securitySetupProvider.notifier).enableBiometric();
        logger.i('Biometria włączona w UI');
      } catch (e) {
        logger.e('Błąd biometrii w UI', error: e);
      }
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const InfoCard(
            icon: Icons.security,
            title: 'Dodatkowe zabezpieczenie',
            description: 'Ustaw PIN lub biometrię...',
          ),
          const SizedBox(height: 30),
          PinTile(
            pinSet: state.pinSet,
            onSetup: onSetupPin, // Teraz sync VoidCallback
          ),
          const SizedBox(height: 20),
          if (state.biometricAvailable)
            BiometricTile(
              enabled: state.biometricSet,
              onSetup: state.pinSet ? onSetupBiometric : () {},
            ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: state.canFinish
                ? () async {
                    await ref
                        .read(securitySetupProvider.notifier)
                        .completeSetup();
                    if (context.mounted) context.go(AppRoutes.home);
                  }
                : null,
            child: const Text('Zakończ konfigurację'),
          ),
          const SizedBox(height: 20),
          Button(
            labelKey: LocaleKeys.common_skip,
            variant: AppButtonVariant.text,
            onPressed: () {
              ref.read(securitySetupProvider.notifier).skipSetup();
              if (context.mounted) context.go(AppRoutes.home);
            },
          ),
        ],
      ),
    );
  }
}
