import 'package:flutter/material.dart';

AppBarTheme buildAppBarTheme(ColorScheme colorScheme) {
  return AppBarTheme(
    elevation: 0,
    centerTitle: true,
    backgroundColor: colorScheme.surface,
    foregroundColor: colorScheme.onSurface,
    titleTextStyle: TextStyle(
      color: colorScheme.onSurface,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    ),
    iconTheme: IconThemeData(color: colorScheme.onSurface),
  );
}
