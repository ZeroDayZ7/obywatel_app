// lib/core/security/security_setup/presentation/security_setup_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/tokens/layout_tokens.dart';
import 'package:obywatel_plus/core/errors/global_error_provider.dart';
import 'package:obywatel_plus/core/security/security_setup/presentation/widget/retry_view.dart';
import 'package:obywatel_plus/core/security/security_setup/presentation/widget/security_setup_body.dart';
import 'package:obywatel_plus/core/security/security_setup/security_setup_notifier.dart';

class SecuritySetupScreen extends ConsumerWidget {
  const SecuritySetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(securitySetupProvider, (prev, next) {
      next.whenOrNull(
        error: (error, _) {
          ref.read(globalNotificationProvider.notifier).showFromError(error);
        },
      );
    });

    final setupAsync = ref.watch(securitySetupProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isFullWidth = screenWidth < Layout.maxWidth;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isFullWidth ? double.infinity : Layout.maxWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: setupAsync.when(
              // TUTAJ PODMIENIAMY:
              loading: () => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 24),
                    Text(
                      LocaleKeys.security_setup_processing.tr(),
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      LocaleKeys.security_setup_wait_moment.tr(),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              error: (error, stack) => RetryView(
                onRetry: () => ref.invalidate(securitySetupProvider),
              ),
              data: (state) => SecuritySetupBody(state: state),
            ),
          ),
        ),
      ),
    );
  }
}
