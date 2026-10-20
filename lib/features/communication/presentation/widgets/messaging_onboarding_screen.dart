import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/communication/application/messaging_activation_controller.dart';
import 'package:obywatel_plus/features/communication/domain/models/messaging_activation_state.dart';

class MessagingOnboardingScreen extends ConsumerWidget {
  const MessagingOnboardingScreen({
    super.key,
    this.activationState,
  });

  final MessagingActivationState? activationState;

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

    final currentState = activationState ?? state.value ?? const MessagingActivationState();
    final termsText = currentState.termsText?.trim();
    final currentTermsVersion = currentState.currentTermsVersion?.trim();
    final hasUsableTerms = currentState.hasUsableTerms;

    final errorMessage = currentState.errorMessage ??
        (!hasUsableTerms
            ? 'Nie pobrano treści regulaminu. Spróbuj pobrać regulamin ponownie.'
            : null);

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
                      'Aktywacja komunikatora',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Regulamin',
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (currentTermsVersion != null && currentTermsVersion.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Wersja: $currentTermsVersion',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    if (hasUsableTerms)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          termsText ?? '',
                          style: textTheme.bodyLarge,
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Brak treści regulaminu do akceptacji. Pobierz regulamin ponownie, aby kontynuować.',
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    if (errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          errorMessage,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: state.isLoading || !hasUsableTerms
                          ? null
                          : () => controller.acceptCurrentTerms(),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Akceptuję regulamin'),
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: state.isLoading ? null : () => controller.load(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Pobierz regulamin ponownie'),
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
