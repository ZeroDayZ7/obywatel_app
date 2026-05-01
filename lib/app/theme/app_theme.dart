import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/theme/app_bar_theme.dart';
import 'package:obywatel_plus/app/theme/app_colors.dart';
import 'package:obywatel_plus/app/theme/app_text_styles.dart';
import 'package:obywatel_plus/app/theme/extensions/shadow_theme.dart';
import 'package:obywatel_plus/app/theme/extensions/toast_theme.dart';

class AppTheme {
  static ThemeData buildTheme(Brightness mode) {
    final bool isDark = mode == Brightness.dark;
    final colorScheme = _colorScheme(isDark);

    return ThemeData(
      useMaterial3: true,
      brightness: mode,
      colorScheme: colorScheme,
      appBarTheme: buildAppBarTheme(isDark),
      textTheme: _textTheme(isDark),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: isDark ? Colors.white30 : Colors.black38,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
      extensions: [_shadowTheme(isDark), _toastTheme(isDark)],
    );
  }

  static ColorScheme _colorScheme(bool isDark) {
    return isDark
        ? const ColorScheme.dark(
            primary: Colors.cyan,
            secondary: Colors.cyanAccent,
            surface: AppColors.backgroundDark,
            onSurface: Colors.white,
            onSecondary: Colors.black,
            error: AppColors.error,
          )
        : const ColorScheme.light(
            primary: Colors.cyan,
            secondary: Colors.cyan,
            surface: AppColors.backgroundLight,
            onSurface: AppColors.textPrimaryLight,
            onSecondary: Colors.white,
            error: AppColors.error,
          );
  }

  static TextTheme _textTheme(bool isDark) {
    final color = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;
    final secondary = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

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
