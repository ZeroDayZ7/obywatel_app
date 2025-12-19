import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/theme/app_colors.dart';

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

  /// FABRYKA: tworzy instancję zależnie od trybu jasny/ciemny
  factory ToastTheme.fromMode(bool isDark) {
    return ToastTheme(
      successColor: isDark ? Colors.greenAccent : Colors.green,
      errorColor: AppColors.error,
      infoColor: isDark ? Colors.blueAccent : AppColors.accent,
      textStyle: const TextStyle(color: Colors.white, fontSize: 14),
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
