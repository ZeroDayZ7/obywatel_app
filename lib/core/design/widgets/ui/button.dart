import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, text, danger, textDanger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.fullWidth = false,
  });

  static const double _buttonHeight = 52.0;
  static const double _loaderSize = 24.0;

  @override
  Widget build(BuildContext context) {
    final Widget content = isLoading
        ? SizedBox(
            width: _loaderSize,
            height: _loaderSize,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(_loaderColor(context)),
            ),
          )
        : Text(label);

    final Widget child = Center(child: content);

    switch (variant) {
      case AppButtonVariant.primary:
        return _buildFullWidthAwareButton(
          context,
          ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              minimumSize: Size(
                fullWidth ? double.infinity : 88,
                _buttonHeight,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: child,
          ),
        );

      case AppButtonVariant.secondary:
        return _buildFullWidthAwareButton(
          context,
          OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
              foregroundColor: Theme.of(context).colorScheme.primary,
              minimumSize: Size(
                fullWidth ? double.infinity : 88,
                _buttonHeight,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: child,
          ),
        );

      case AppButtonVariant.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            minimumSize: const Size(48, 48),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: isLoading
              ? SizedBox(
                  width: _loaderSize,
                  height: _loaderSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                )
              : Text(label),
        );

      case AppButtonVariant.textDanger:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            minimumSize: const Size(48, 48),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: isLoading
              ? SizedBox(
                  width: _loaderSize,
                  height: _loaderSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.error,
                    ),
                  ),
                )
              : Text(label),
        );

      case AppButtonVariant.danger:
        return _buildFullWidthAwareButton(
          context,
          ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
              minimumSize: Size(
                fullWidth ? double.infinity : 88,
                _buttonHeight,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: child,
          ),
        );
    }
  }

  Widget _buildFullWidthAwareButton(BuildContext context, Widget button) {
    if (!fullWidth) return button;
    return SizedBox(width: double.infinity, child: button);
  }

  Color _loaderColor(BuildContext context) {
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.danger:
        return Theme.of(context).colorScheme.onPrimary;
      case AppButtonVariant.secondary:
      case AppButtonVariant.text:
        return Theme.of(context).colorScheme.primary;
      case AppButtonVariant.textDanger:
        return Theme.of(context).colorScheme.error;
    }
  }
}
