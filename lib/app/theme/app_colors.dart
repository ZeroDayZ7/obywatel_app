import 'package:flutter/material.dart';

/// Surowa paleta wartości kolorystycznych (Palette Tokens).
/// Zbudowana zgodnie z wymogami Material 3.
///
/// UWAGA: Nie używaj tych kolorów bezpośrednio w widgetach UI.
/// Korzystaj z `Theme.of(context).colorScheme`.
abstract final class AppColors {
  // Brand / Cyan
  static const cyanPrimary = Color(0xFF00BCD4);
  static const cyanSecondary = Color(0xFF00E5FF);

  // Matrix / Cyberpunk
  static const matrixGreen = Color(0xFF00FF66);
  static const matrixDarkSurface = Color(0xFF0D0D0D);
  static const matrixContainer = Color(0xFF003311);

  // Backgrounds & Surfaces
  static const lightBackground = Color(0xFFF5F7FA);
  static const lightSurfaceContainer = Color(0xFFFFFFFF);

  static const darkBackground = Color(0xFF1F1F1F);
  static const darkSurfaceContainer = Color(0xFF2A2A2A);

  // Status Colors
  static const error = Color(0xFFD32F2F);
  static const onError = Color(0xFFFFFFFF);
  static const success = Color(0xFF2E7D32);
}
