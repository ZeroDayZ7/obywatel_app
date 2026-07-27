// lib/app/theme/app_theme.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/theme/app_bar_theme.dart';
import 'package:obywatel_plus/app/theme/app_colors.dart';
import 'package:obywatel_plus/app/theme/app_text_theme.dart';
import 'package:obywatel_plus/app/theme/extensions/shadow_theme.dart';
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
      textTheme: AppTextTheme.buildTextTheme(colorScheme),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.4),
        selectedItemColor: colorScheme.primary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      extensions: [
        ShadowTheme.fromMode(isDark),
        ToastTheme.fromColorScheme(colorScheme),
      ],
    );
  }

  static ColorScheme _colorScheme(AppThemeType type) {
    // Definica colorScheme...
    switch (type) {
      case AppThemeType.matrix:
        return const ColorScheme.dark(
          primary: AppColors.matrixGreen,
          onPrimary: Colors.black,
          secondary: AppColors.matrixGreen,
          onSecondary: Colors.black,
          surface: AppColors.matrixDarkSurface,
          onSurface: AppColors.matrixGreen,
          surfaceContainerHigh: AppColors.matrixContainer,
          outlineVariant: Color(0xFF005522),
          error: AppColors.error,
          onError: AppColors.onError,
        );
      case AppThemeType.dark:
        return const ColorScheme.dark(
          primary: AppColors.cyanPrimary,
          onPrimary: Colors.black,
          secondary: AppColors.cyanSecondary,
          onSecondary: Colors.black,
          surface: AppColors.darkBackground,
          onSurface: Color(0xFFE6E8EC),
          surfaceContainerHigh: AppColors.darkSurfaceContainer,
          outlineVariant: Color(0xFF3D4046),
          error: AppColors.error,
          onError: AppColors.onError,
        );
      case AppThemeType.light:
      case AppThemeType.system:
        return const ColorScheme.light(
          primary: AppColors.cyanPrimary,
          onPrimary: Colors.white,
          secondary: AppColors.cyanSecondary,
          onSecondary: Colors.white,
          surface: AppColors.lightBackground,
          onSurface: Color(0xFF1A1C1E),
          surfaceContainerHigh: AppColors.lightSurfaceContainer,
          outlineVariant: Color(0xFFE0E2E8),
          error: AppColors.error,
          onError: AppColors.onError,
        );
    }
  }
}
