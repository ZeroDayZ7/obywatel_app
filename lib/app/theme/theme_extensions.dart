import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/theme/extensions/status_colors_theme.dart';

extension BuildContextThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  StatusColorsTheme get statusColors =>
      theme.extension<StatusColorsTheme>() ??
      StatusColorsTheme.fromColorScheme(colorScheme);
}
