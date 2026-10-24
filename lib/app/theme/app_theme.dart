// lib/app/theme/app_theme.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/theme/app_bar_theme.dart';
import 'package:obywatel_plus/app/theme/app_colors.dart';
import 'package:obywatel_plus/app/theme/app_text_theme.dart';
import 'package:obywatel_plus/app/theme/extensions/shadow_theme.dart';
import 'package:obywatel_plus/app/theme/extensions/status_colors_theme.dart';
import 'package:obywatel_plus/app/theme/extensions/switch_theme.dart';
import 'package:obywatel_plus/app/theme/extensions/toast_theme.dart';
import 'package:obywatel_plus/app/theme/input_decoration_theme.dart';

enum AppThemeType { system, light, dark, matrix }

abstract final class AppTheme {
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
      appBarTheme: buildAppBarTheme(colorScheme),
      inputDecorationTheme: buildInputDecorationTheme(colorScheme),
      switchTheme: buildSwitchTheme(isDark, colorScheme),
      textTheme: AppTextTheme.buildTextTheme(colorScheme),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.4),
        selectedItemColor: colorScheme.primary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      extensions: [
        ShadowTheme.fromMode(isDark, shadowColor: colorScheme.shadow),
        ToastTheme.fromColorScheme(colorScheme),
        StatusColorsTheme.fromColorScheme(colorScheme),
      ],
    );
  }

  static ColorScheme _colorScheme(AppThemeType type) {
    switch (type) {
      case AppThemeType.matrix:
        return const ColorScheme.dark(
          primary: AppColors.matrixGreen,
          onPrimary: Colors.black,
          primaryContainer: AppColors.matrixContainer,
          onPrimaryContainer: AppColors.matrixGreen,
          secondary: AppColors.matrixSecondary,
          onSecondary: Colors.black,
          tertiary: AppColors.matrixTertiary,
          onTertiary: Colors.black,
          surface: AppColors.matrixDarkSurface,
          onSurface: AppColors.matrixOnSurface,
          surfaceContainerHigh: AppColors.matrixContainer,
          outline: AppColors.matrixGreen,
          outlineVariant: AppColors.matrixOutlineVariant,
          error: AppColors.darkError,
          onError: AppColors.darkOnError,
        );
      case AppThemeType.dark:
        return const ColorScheme.dark(
          primary: AppColors.cyanPrimary,
          onPrimary: Colors.black,
          primaryContainer: AppColors.darkPrimaryContainer,
          onPrimaryContainer: AppColors.darkOnPrimaryContainer,
          secondary: AppColors.cyanSecondary,
          onSecondary: Colors.black,
          tertiary: AppColors.darkTertiary,
          onTertiary: Colors.black,
          surface: AppColors.darkBackground,
          onSurface: AppColors.darkOnSurface,
          surfaceContainerHigh: AppColors.darkSurfaceContainer,
          outline: AppColors.darkOutline,
          outlineVariant: AppColors.darkOutlineVariant,
          error: AppColors.darkError,
          onError: AppColors.darkOnError,
        );
      case AppThemeType.light:
      case AppThemeType.system:
        return const ColorScheme.light(
          primary: AppColors.lightPrimary,
          onPrimary: Colors.white,
          primaryContainer: AppColors.lightPrimaryContainer,
          onPrimaryContainer: AppColors.lightOnPrimaryContainer,
          secondary: AppColors.lightSecondary,
          onSecondary: Colors.white,
          tertiary: AppColors.lightTertiary,
          onTertiary: Colors.white,
          surface: AppColors.lightBackground,
          onSurface: AppColors.lightOnSurface,
          surfaceContainerHigh: AppColors.lightSurfaceContainer,
          outline: AppColors.lightOutline,
          outlineVariant: AppColors.lightOutlineVariant,
          error: AppColors.error,
          onError: AppColors.onError,
        );
    }
  }
}
