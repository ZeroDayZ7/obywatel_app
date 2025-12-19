import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'extensions/toast_theme.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.backgroundLight,
      onSurface: AppColors.textPrimary,
      onSecondary: AppColors.textSecondary,
      error: AppColors.error,
    ),

    appBarTheme: const AppBarTheme(elevation: 0),

    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(),
      bodyLarge: TextStyle(),
      bodySmall: TextStyle(),
      titleLarge: TextStyle(fontWeight: FontWeight.bold),
    ),

    extensions: [
      ToastTheme(
        successColor: Colors.green,
        errorColor: AppColors.error,
        infoColor: AppColors.accent,
        textStyle: const TextStyle(color: Colors.white, fontSize: 14),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ],
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 226, 226, 226),
      secondary: Color.fromARGB(255, 92, 92, 92),
      surface: AppColors.backgroundDark,
      onSurface: Color.fromARGB(255, 103, 221, 230),
      onSecondary: Color.fromARGB(255, 211, 211, 211),
      error: AppColors.error,
    ),

    appBarTheme: const AppBarTheme(elevation: 0),

    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(),
      bodyLarge: TextStyle(),
      bodySmall: TextStyle(),
      titleLarge: TextStyle(fontWeight: FontWeight.bold),
    ),

    extensions: [
      ToastTheme(
        successColor: Colors.greenAccent,
        errorColor: Colors.redAccent,
        infoColor: Colors.blueAccent,
        textStyle: const TextStyle(color: Colors.white, fontSize: 14),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ],
  );
}
