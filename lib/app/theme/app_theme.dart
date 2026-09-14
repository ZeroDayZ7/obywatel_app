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
    switch (type) {
      case AppThemeType.matrix:
        return const ColorScheme.dark(
          primary: AppColors.matrixGreen,
          onPrimary: Colors.black,
          primaryContainer: AppColors.matrixContainer,
          onPrimaryContainer: AppColors.matrixGreen,
          secondary: Color(0xFF00CC55),
          onSecondary: Colors.black,
          tertiary: Color(0xFF00FFAA),
          onTertiary: Colors.black,
          surface: AppColors.matrixDarkSurface,
          onSurface: AppColors.matrixGreen,
          surfaceContainerHigh: AppColors.matrixContainer,
          outline: AppColors.matrixGreen,
          outlineVariant: Color(0xFF005522),
          error: AppColors.error,
          onError: AppColors.onError,
        );
      case AppThemeType.dark:
        return const ColorScheme.dark(
          primary: AppColors.cyanPrimary,
          onPrimary: Colors.black,
          primaryContainer: Color(0xFF004D40),
          onPrimaryContainer: Color(0xFF80DEEA),
          secondary: AppColors.cyanSecondary,
          onSecondary: Colors.black,
          tertiary: Color(0xFFFFB74D),
          onTertiary: Colors.black,
          surface: AppColors.darkBackground,
          onSurface: Color(0xFFE6E8EC),
          surfaceContainerHigh: AppColors.darkSurfaceContainer,
          outline: Color(0xFF8E918F),
          outlineVariant: Color(0xFF3D4046),
          error: AppColors.error,
          onError: AppColors.onError,
        );
      case AppThemeType.light:
      case AppThemeType.system:
        return const ColorScheme.light(
          primary: AppColors.cyanPrimary,
          onPrimary: Colors.white,
          primaryContainer: Color(0xFFE0F7FA),
          onPrimaryContainer: Color(0xFF006064),
          secondary: AppColors.cyanSecondary,
          onSecondary: Colors.white,
          tertiary: Color(0xFFF57C00),
          onTertiary: Colors.white,
          surface: AppColors.lightBackground,
          onSurface: Color(0xFF1A1C1E),
          surfaceContainerHigh: AppColors.lightSurfaceContainer,
          outline: Color(0xFF74777F),
          outlineVariant: Color(0xFFE0E2E8),
          error: AppColors.error,
          onError: AppColors.onError,
        );
    }
  }
}
