import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';
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

    return AppScaffold(
      size: ContainerSize.narrow,
      alignment: Alignment.center,
      child: setupAsync.when(
        loading: () => Column(
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
        error: (error, stack) =>
            RetryView(onRetry: () => ref.invalidate(securitySetupProvider)),
        data: (state) => SecuritySetupBody(state: state),
      ),
    );
  }
}
