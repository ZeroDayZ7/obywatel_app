import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/theme/app_bar_theme.dart';
import 'package:obywatel_plus/app/theme/app_colors.dart';
import 'package:obywatel_plus/app/theme/app_text_styles.dart';

enum AppThemeType { system, light, dark, matrix }

class AppTheme {
  static ThemeData buildTheme(
    AppThemeType type, [
    Brightness? platformBrightness,
  ]) {
    final effectiveType = type == AppThemeType.system
        ? ((platformBrightness ??
                      PlatformDispatcher.instance.platformBrightness) ==
                  Brightness.dark
              ? AppThemeType.dark
              : AppThemeType.light)
        : type;

    final colorScheme = _colorScheme(effectiveType);
    final isDark = effectiveType != AppThemeType.light;

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: buildAppBarTheme(isDark),
      textTheme: _textTheme(colorScheme, isDark),
      // ... Twoje inputDecorations, extensions itp.
    );
  }

  static ColorScheme _colorScheme(AppThemeType type) {
    switch (type) {
      case AppThemeType.matrix:
        return const ColorScheme.dark(
          primary: Color(0xFF00FF66), // Neon Matrix Green
          secondary: Color(0xFF003311),
          surface: Color(0xFF0D0D0D),
          onSurface: Color(0xFF00FF66),
          onPrimary: Colors.black,
          error: AppColors.error,
        );
      case AppThemeType.dark:
        return const ColorScheme.dark(
          primary: Colors.cyan,
          secondary: Colors.cyanAccent,
          surface: AppColors.backgroundDark,
          onSurface: Colors.white,
          error: AppColors.error,
        );
      case AppThemeType.light:
      case AppThemeType.system:
        return const ColorScheme.light(
          primary: Colors.cyan,
          secondary: Colors.cyan,
          surface: AppColors.backgroundLight,
          onSurface: AppColors.textPrimaryLight,
          error: AppColors.error,
        );
    }
  }

  static TextTheme _textTheme(ColorScheme colorScheme, bool isDark) {
    return TextTheme(
      headlineMedium: AppTextStyles.headline.copyWith(
        color: colorScheme.onSurface,
      ),
      titleLarge: AppTextStyles.subtitle.copyWith(
        color: colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      bodyMedium: AppTextStyles.body.copyWith(color: colorScheme.onSurface),
    );
  }
}
