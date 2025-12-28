import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/widgets/ui/button.dart';

class RetryView extends StatelessWidget {
  final VoidCallback onRetry;

  const RetryView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppButton(
        labelKey: LocaleKeys.security_setup_retry,
        onPressed: onRetry,
        variant: AppButtonVariant.primary,
        fullWidth: false,
      ),
    );
  }
}
