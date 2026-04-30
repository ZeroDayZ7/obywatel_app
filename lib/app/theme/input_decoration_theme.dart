import 'package:flutter/material.dart';

import 'app_colors.dart';

InputDecorationTheme buildInputDecorationTheme(
  bool isDark,
  ColorScheme colorScheme,
) {
  return InputDecorationTheme(
    labelStyle: TextStyle(
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
    ),
    floatingLabelStyle: TextStyle(color: colorScheme.primary),
    errorStyle: TextStyle(color: AppColors.error, fontWeight: FontWeight.w500),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: colorScheme.primary, width: 2),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.error, width: 2),
    ),
  );
}
