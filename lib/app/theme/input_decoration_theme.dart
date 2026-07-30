import 'package:flutter/material.dart';

InputDecorationTheme buildInputDecorationTheme(ColorScheme colorScheme) {
  return InputDecorationTheme(
    labelStyle: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7)),
    floatingLabelStyle: TextStyle(color: colorScheme.primary),
    errorStyle: TextStyle(
      color: colorScheme.error,
      fontWeight: FontWeight.w500,
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: colorScheme.onSurface.withValues(alpha: 0.38),
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: colorScheme.primary, width: 2),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: colorScheme.error),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: colorScheme.error, width: 2),
    ),
  );
}
