import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/theme/app_text_styles.dart';
import 'package:obywatel_plus/app/theme/input_decoration_theme.dart';

import 'app_colors.dart';
import 'extensions/shadow_theme.dart';
import 'extensions/toast_theme.dart';

class AppTheme {
  static ThemeData buildTheme(Brightness mode) {
    final bool isDark = mode == Brightness.dark;
    final colorScheme = _colorScheme(isDark);

    return ThemeData(
      useMaterial3: true,
      brightness: mode,
      appBarTheme: const AppBarTheme(elevation: 0),
      colorScheme: _colorScheme(isDark),
      textTheme: _textTheme(isDark),
      inputDecorationTheme: buildInputDecorationTheme(isDark, colorScheme),
      extensions: [_shadowTheme(isDark), _toastTheme(isDark)],
      switchTheme: SwitchThemeData(
        // 🔘 Thumb
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary; // idealne z ColorScheme
          }
          return isDark
              ? colorScheme.onSurface.withValues(alpha:0.7)
              : colorScheme.onSurface.withValues(alpha:0.6);
        }),

        // 🟩 Track = TŁO
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.secondary; // ✅ ON = primary
          }
          return isDark ? colorScheme.surface : colorScheme.primary;
        }),

        // ▢ Obramowanie (OFF)
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return colorScheme.outline;
        }),

        trackOutlineWidth: WidgetStateProperty.all(1.5),
      ),
    );
  }

  // ---------- Color Scheme ----------
  static ColorScheme _colorScheme(bool isDark) {
    return isDark
        ? const ColorScheme.dark(
            primary: AppColors.primary,
            secondary: Color.fromARGB(255, 92, 92, 92),
            surface: AppColors.backgroundDark,
            onSurface: Color.fromARGB(255, 255, 255, 255),
            onSecondary: Color.fromARGB(255, 211, 211, 211),
            error: AppColors.error,
          )
        : const ColorScheme.light(
            primary: AppColors.primary,
            secondary: Color.fromARGB(255, 80, 80, 80),
            surface: AppColors.backgroundLight,
            onSurface: AppColors.textPrimary,
            onSecondary: Color.fromARGB(255, 211, 211, 211),
            error: AppColors.error,
          );
  }

  // ---------- Text Theme ----------
  static TextTheme _textTheme(bool isDark) {
    final color = isDark ? Colors.white : AppColors.textPrimary;
    final secondary = isDark ? Colors.white70 : AppColors.textSecondary;

    return TextTheme(
      headlineMedium: AppTextStyles.headline.copyWith(color: color),
      titleLarge: AppTextStyles.subtitle.copyWith(color: secondary),
      bodyMedium: AppTextStyles.body.copyWith(color: color),
      labelLarge: AppTextStyles.button.copyWith(color: Colors.white),
    );
  }

  static ShadowTheme _shadowTheme(bool isDark) => ShadowTheme.fromMode(isDark);
  static ToastTheme _toastTheme(bool isDark) => ToastTheme.fromMode(isDark);
}
