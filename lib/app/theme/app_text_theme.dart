// lib/app/theme/app_text_theme.dart
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/theme/app_text_styles.dart';

abstract final class AppTextTheme {
  static TextTheme buildTextTheme(ColorScheme colorScheme) {
    final baseTextTheme = colorScheme.brightness == Brightness.dark
        ? Typography.material2021().white
        : Typography.material2021().black;

    return baseTextTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ).copyWith(
      headlineMedium: AppTextStyles.headline.copyWith(
        color: colorScheme.onSurface,
      ),
      titleLarge: AppTextStyles.subtitle.copyWith(
        color: colorScheme.onSurface,
      ),
      bodyMedium: AppTextStyles.body.copyWith(color: colorScheme.onSurface),
      labelLarge: AppTextStyles.button.copyWith(color: colorScheme.onSurface),
    );
  }
}
