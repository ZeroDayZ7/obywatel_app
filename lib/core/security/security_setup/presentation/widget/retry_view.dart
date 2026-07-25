import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';

class RetryView extends StatelessWidget {
  final VoidCallback onRetry;

  const RetryView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tytuł sesji wygasłej
          Text(
            LocaleKeys.login_2fa_session_expired_title.tr(),
            style: theme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Podtytuł / opis
          Text(
            LocaleKeys.login_2fa_session_expired_subtitle.tr(),
            style: theme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Przycisk retry
          AppButton(
            label: LocaleKeys.security_setup_retry.tr(),
            onPressed: onRetry,
            variant: AppButtonVariant.primary,
            fullWidth: false,
          ),
        ],
      ),
    );
  }
}
