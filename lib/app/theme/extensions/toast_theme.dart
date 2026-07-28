import 'package:flutter/material.dart';

enum ToastType { success, error, info }

class ToastTheme extends ThemeExtension<ToastTheme> {
  final Color successColor;
  final Color errorColor;
  final Color infoColor;
  final TextStyle textStyle;
  final BorderRadius borderRadius;

  const ToastTheme({
    required this.successColor,
    required this.errorColor,
    required this.infoColor,
    required this.textStyle,
    required this.borderRadius,
  });

  /// FABRYKA: Tworzy instancję ToastTheme na podstawie ColorScheme motywu
  factory ToastTheme.fromColorScheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return ToastTheme(
      successColor: isDark ? const Color(0xFF4CAF50) : const Color(0xFF2E7D32),
      errorColor: colorScheme.error,
      infoColor: colorScheme.primary,
      textStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
    );
  }

  @override
  ToastTheme copyWith({
    Color? successColor,
    Color? errorColor,
    Color? infoColor,
    TextStyle? textStyle,
    BorderRadius? borderRadius,
  }) {
    return ToastTheme(
      successColor: successColor ?? this.successColor,
      errorColor: errorColor ?? this.errorColor,
      infoColor: infoColor ?? this.infoColor,
      textStyle: textStyle ?? this.textStyle,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  ToastTheme lerp(ThemeExtension<ToastTheme>? other, double t) {
    if (other is! ToastTheme) return this;
    return ToastTheme(
      successColor: Color.lerp(successColor, other.successColor, t)!,
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,
      infoColor: Color.lerp(infoColor, other.infoColor, t)!,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t)!,
    );
  }
}
