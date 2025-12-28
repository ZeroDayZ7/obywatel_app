import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/errors/global_error_provider.dart';
import 'package:obywatel_plus/core/security/security_setup/presentation/widget/retry_view.dart';
import 'package:obywatel_plus/core/security/security_setup/presentation/widget/security_setup_body.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_notifier.dart';

class SecuritySetupScreen extends ConsumerWidget {
  const SecuritySetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ JEDYNE miejsce na side-effects
    ref.listen(securitySetupProvider, (prev, next) {
      next.whenOrNull(
        error: (error, _) {
          ref.read(globalNotificationProvider.notifier).showFromError(error);
        },
      );
    });

    final setupAsync = ref.watch(securitySetupProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ustawienia bezpieczeństwa')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: setupAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) =>
              RetryView(onRetry: () => ref.invalidate(securitySetupProvider)),
          data: (state) => SecuritySetupBody(state: state),
        ),
      ),
    );
  }
}
