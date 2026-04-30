import 'package:flutter/material.dart';

import 'app_colors.dart';

AppBarTheme buildAppBarTheme(bool isDark) {
  final foreground = isDark
      ? AppColors.textPrimaryDark
      : AppColors.textPrimaryLight;
  final background = isDark
      ? AppColors.backgroundDark
      : AppColors.backgroundLight;

  return AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: background,
    foregroundColor: foreground,
    titleTextStyle: TextStyle(
      color: foreground,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    ),
    iconTheme: IconThemeData(color: foreground),
  );
}
