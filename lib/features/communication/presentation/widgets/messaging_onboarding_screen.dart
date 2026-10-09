import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/communication/application/messaging_activation_controller.dart';

class MessagingOnboardingScreen extends ConsumerWidget {
  const MessagingOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(messagingActivationControllerProvider);
    final controller = ref.read(messagingActivationControllerProvider.notifier);

    if (state.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final activationState = state.value ?? const MessagingActivationState();
    final termsText = activationState.terms?.text ??
        'Komunikator XYZ umożliwia prowadzenie prywatnych rozmów z innymi użytkownikami Obywatel Plus. Przed rozpoczęciem korzystania z komunikatora zapoznaj się z zasadami usługi i potwierdź ich akceptację.';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Komunikator XYZ',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Aktywacja i regulamin',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        termsText,
                        style: textTheme.bodyLarge,
                      ),
                    ),
                    if (activationState.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          activationState.errorMessage!,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: state.isLoading ? null : () => controller.acceptCurrentTerms(),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Akceptuję regulamin'),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: state.isLoading ? null : () => controller.declineTerms(),
                      icon: const Icon(Icons.close),
                      label: const Text('Zrezygnuj'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
