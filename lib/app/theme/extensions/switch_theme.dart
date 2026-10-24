import 'package:flutter/material.dart';

SwitchThemeData buildSwitchTheme(bool isDark, ColorScheme colorScheme) {
  return SwitchThemeData(
    // 🔘 Thumb
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return colorScheme.onPrimary;
      }
      return isDark
          ? colorScheme.onSurface.withValues(alpha: 0.7)
          : colorScheme.onSurface.withValues(alpha: 0.6);
    }),

    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return colorScheme.primary;
      }
      return colorScheme.surfaceContainerHighest;
    }),

    trackOutlineColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.transparent;
      }
      return colorScheme.outline;
    }),

    trackOutlineWidth: WidgetStateProperty.all(1.5),
  );
}
