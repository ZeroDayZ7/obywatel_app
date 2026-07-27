// lib/app/theme/app_text_theme.dart
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/theme/app_text_styles.dart';

abstract final class AppTextTheme {
  static TextTheme buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      headlineMedium: AppTextStyles.headline.copyWith(
        color: colorScheme.onSurface,
      ),
      titleLarge: AppTextStyles.subtitle.copyWith(
        color: colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      bodyMedium: AppTextStyles.body.copyWith(color: colorScheme.onSurface),
      labelLarge: AppTextStyles.button.copyWith(color: colorScheme.onPrimary),
    );
  }
}
