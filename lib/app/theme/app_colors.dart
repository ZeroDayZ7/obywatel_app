import 'package:flutter/material.dart';

/// Surowa paleta wartości kolorystycznych (Palette Tokens).
/// Zbudowana zgodnie z wymogami Material 3.
///
/// Prefer `Theme.of(context).colorScheme` for semantic UI colors.
/// Use these tokens only for fixed brand, service, and document accents.
abstract final class AppColors {
  // Brand / Cyan
  static const cyanPrimary = Color(0xFF00BCD4);
  static const lightPrimary = Color(0xFF007C91);
  static const cyanSecondary = Color(0xFF00E5FF);
  static const lightSecondary = Color(0xFF006A70);
  static const lightTertiary = Color(0xFFB45309);

  // Home service accents
  static const serviceWork = Color(0xFF0077FF);
  static const servicePayments = Color(0xFFFFD700);
  static const serviceHealth = Color(0xFFFF0099);
  static const serviceEducation = Color(0xFF00D4FF);
  static const serviceTest = Color(0xFF0099FF);

  // Document type accents
  static const documentIdentity = Color(0xFF2196F3);
  static const documentLicense = Color(0xFF4CAF50);
  static const documentPassport = Color(0xFF1E88E5);
  static const documentVehicle = Color(0xFFFB8C00);
  static const documentFamily = Color(0xFF43A047);
  static const documentDefault = Color(0xFF607D8B);

  // Matrix / Cyberpunk
  static const matrixGreen = Color(0xFF00FF66);
  static const matrixSecondary = Color(0xFF00CC55);
  static const matrixTertiary = Color(0xFF00FFAA);
  static const matrixOnSurface = Color(0xFFB9F6CA);
  static const matrixDarkSurface = Color(0xFF0D0D0D);
  static const matrixContainer = Color(0xFF003311);
  static const matrixOutlineVariant = Color(0xFF005522);

  // Backgrounds & Surfaces
  static const lightBackground = Color(0xFFF5F7FA);
  static const lightSurfaceContainer = Color(0xFFFFFFFF);
  static const lightPrimaryContainer = Color(0xFFE0F7FA);
  static const lightOnPrimaryContainer = Color(0xFF006064);
  static const lightOnSurface = Color(0xFF1A1C1E);
  static const lightOutline = Color(0xFF74777F);
  static const lightOutlineVariant = Color(0xFFE0E2E8);

  static const darkBackground = Color(0xFF1F1F1F);
  static const darkSurfaceContainer = Color(0xFF2A2A2A);
  static const darkPrimaryContainer = Color(0xFF004D40);
  static const darkOnPrimaryContainer = Color(0xFF80DEEA);
  static const darkTertiary = Color(0xFFFFB74D);
  static const darkOnSurface = Color(0xFFE6E8EC);
  static const darkOutline = Color(0xFF8E918F);
  static const darkOutlineVariant = Color(0xFF3D4046);

  // Status Colors
  static const error = Color(0xFFD32F2F);
  static const darkError = Color(0xFFFF8A80);
  static const onError = Color(0xFFFFFFFF);
  static const darkOnError = Color(0xFF5F0000);
  static const success = Color(0xFF2E7D32);
  static const darkSuccess = Color(0xFF81C784);
  static const darkOnSuccess = Color(0xFF123018);
  static const onSuccess = Color(0xFFFFFFFF);
  static const warning = Color(0xFFF9A825);
  static const darkWarning = Color(0xFFFFD54F);
  static const onWarning = Color(0xFF1F1F1F);
  static const info = Color(0xFF1976D2);
  static const darkInfo = Color(0xFF64B5F6);
  static const onInfo = Color(0xFFFFFFFF);
  static const pending = Color(0xFFFFB300);
  static const darkPending = Color(0xFFFFB74D);
}
