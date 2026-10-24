import 'package:flutter/material.dart';

InputDecorationTheme buildInputDecorationTheme(ColorScheme colorScheme) {
  const borderRadius = BorderRadius.all(Radius.circular(8));

  return InputDecorationTheme(
    labelStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
    floatingLabelStyle: TextStyle(color: colorScheme.primary),
    errorStyle: TextStyle(
      color: colorScheme.error,
      fontWeight: FontWeight.w500,
    ),
    border: const OutlineInputBorder(borderRadius: borderRadius),
    enabledBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(
        color: colorScheme.onSurface.withValues(alpha: 0.38),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: colorScheme.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: colorScheme.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: colorScheme.error, width: 2),
    ),
  );
}
