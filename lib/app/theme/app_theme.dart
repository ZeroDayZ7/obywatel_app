import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/theme/app_bar_theme.dart';
import 'package:obywatel_plus/app/theme/app_colors.dart';
import 'package:obywatel_plus/app/theme/app_text_styles.dart';
import 'package:obywatel_plus/app/theme/extensions/shadow_theme.dart';
import 'package:obywatel_plus/app/theme/extensions/toast_theme.dart';

class AppTheme {
  // Paleta Cyberpunk / Tech z dołączonej grafiki
  static const _neonCyan = Color(0xFF00E5FF);
  static const _electricBlue = Color(0xFF0088FF);
  static const _deepSpaceNavy = Color(0xFF040A15);
  static const _cardNavy = Color(0xFF0B172A);
  static const _borderBlue = Color(0xFF1E3A5F);

  static ThemeData buildTheme(Brightness mode) {
    final bool isDark = mode == Brightness.dark;
    final colorScheme = _colorScheme(isDark);

    return ThemeData(
      useMaterial3: true,
      brightness: mode,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: buildAppBarTheme(isDark),
      textTheme: _textTheme(isDark),

      // Nowoczesne, przezroczyste pola z cyjanowym akcentem
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? _cardNavy.withValues(alpha: 0.6)
            : Colors.blue.shade50.withValues(alpha: 0.5),

        errorStyle: TextStyle(color: colorScheme.error),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isDark ? _borderBlue : Colors.blue.shade200,
            width: 1.2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),

        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error),
          borderRadius: BorderRadius.circular(12),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Stylizowana nawigacja zgodna z dolnym panelem z mocka
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? _deepSpaceNavy : Colors.white,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: isDark ? const Color(0xFF4A6B94) : Colors.black38,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Karty (CardTheme) w klimacie Tech Glass
      cardTheme: CardThemeData(
        color: isDark ? _cardNavy : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isDark ? _borderBlue : Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),

      extensions: [_shadowTheme(isDark), _toastTheme(isDark)],
    );
  }

  static ColorScheme _colorScheme(bool isDark) {
    return isDark
        ? const ColorScheme.dark(
            primary: _neonCyan,
            onPrimary: Color(0xFF001E2B),
            secondary: _electricBlue,
            onSecondary: Colors.white,
            surface: _deepSpaceNavy,
            onSurface: Color(0xFFE1F5FE),
            error: Color(0xFFFF5252),
          )
        : const ColorScheme.light(
            primary: Color(0xFF0077C2),
            onPrimary: Colors.white,
            secondary: Color(0xFF00A3FF),
            onSecondary: Colors.white,
            surface: Color(0xFFF4F8FA),
            onSurface: Color(0xFF0A192F),
            error: Color(0xFFD32F2F),
          );
  }

  static TextTheme _textTheme(bool isDark) {
    final color = isDark ? const Color(0xFFE1F5FE) : AppColors.textPrimaryLight;
    final secondary = isDark
        ? const Color(0xFF7A9BBF)
        : AppColors.textSecondaryLight;

    return TextTheme(
      headlineMedium: AppTextStyles.headline.copyWith(
        color: color,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: AppTextStyles.subtitle.copyWith(color: secondary),
      bodyMedium: AppTextStyles.body.copyWith(color: color),
      labelLarge: AppTextStyles.button.copyWith(
        color: isDark ? const Color(0xFF001E2B) : Colors.white,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static ShadowTheme _shadowTheme(bool isDark) => ShadowTheme.fromMode(isDark);
  static ToastTheme _toastTheme(bool isDark) => ToastTheme.fromMode(isDark);
}
