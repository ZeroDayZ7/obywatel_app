import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'extensions/toast_theme.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.textPrimary),
    ),
    extensions: [
      ToastTheme(
        successColor: Colors.green,
        errorColor: AppColors.error,
        infoColor: AppColors.accent,
        textStyle: const TextStyle(color: Colors.white, fontSize: 14),
        borderRadius: BorderRadius.circular(12),
      ),
    ],
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryDark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    extensions: [
      ToastTheme(
        successColor: Colors.greenAccent.shade400,
        errorColor: Colors.redAccent,
        infoColor: Colors.blueAccent.shade200,
        textStyle: const TextStyle(color: Colors.white, fontSize: 14),
        borderRadius: BorderRadius.circular(12),
      ),
    ],
  );
}
