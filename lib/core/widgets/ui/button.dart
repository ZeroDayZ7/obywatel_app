import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

enum AppButtonVariant { primary, secondary, text, danger }

class Button extends StatelessWidget {
  final String labelKey;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool fullWidth;

  const Button({
    super.key,
    required this.labelKey,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final label = labelKey.tr();

    final Widget child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : Text(label);

    switch (variant) {
      case AppButtonVariant.primary:
        return _wrapWidth(
          ElevatedButton(onPressed: isLoading ? null : onPressed, child: child),
        );

      case AppButtonVariant.secondary:
        return _wrapWidth(
          OutlinedButton(onPressed: isLoading ? null : onPressed, child: child),
        );

      case AppButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );

      case AppButtonVariant.danger:
        return _wrapWidth(
          ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: child,
          ),
        );
    }
  }

  Widget _wrapWidth(Widget button) {
    if (!fullWidth) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
