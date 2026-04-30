import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';
import 'extensions/shadow_theme.dart';
import 'extensions/toast_theme.dart';

class AppTheme {
  static ThemeData buildTheme(Brightness mode) {
    final bool isDark = mode == Brightness.dark;
    final colorScheme = _colorScheme(isDark);

    return ThemeData(
      useMaterial3: true,
      brightness: mode,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: isDark ? Colors.cyan[400] : Colors.black,
        centerTitle: true,
      ),
      textTheme: _textTheme(isDark),
      extensions: [_shadowTheme(isDark), _toastTheme(isDark)],
    );
  }

  static ColorScheme _colorScheme(bool isDark) {
    return isDark
        ? const ColorScheme.dark(
            primary: Colors.cyan,
            secondary: Colors.cyanAccent,
            surface: Colors.black,
            onSurface: Colors.white,
            onSecondary: Colors.black,
            error: AppColors.error,
          )
        : const ColorScheme.light(
            primary: Colors.cyan,
            secondary: Colors.cyan,
            surface: AppColors.backgroundLight,
            onSurface: AppColors.textPrimary,
            onSecondary: Colors.white,
            error: AppColors.error,
          );
  }

  static TextTheme _textTheme(bool isDark) {
    final color = isDark ? Colors.white : AppColors.textPrimary;
    final secondary = isDark ? Colors.white70 : AppColors.textSecondary;

    return TextTheme(
      headlineMedium: AppTextStyles.headline.copyWith(color: color),
      titleLarge: AppTextStyles.subtitle.copyWith(color: secondary),
      bodyMedium: AppTextStyles.body.copyWith(color: color),
      labelLarge: AppTextStyles.button.copyWith(
        color: isDark ? Colors.black : Colors.white,
      ),
    );
  }

  static ShadowTheme _shadowTheme(bool isDark) => ShadowTheme.fromMode(isDark);
  static ToastTheme _toastTheme(bool isDark) => ToastTheme.fromMode(isDark);
}
