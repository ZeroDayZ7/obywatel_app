import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/theme/app_colors.dart';

class StatusColorsTheme extends ThemeExtension<StatusColorsTheme> {
  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;
  final Color info;
  final Color onInfo;
  final Color pending;

  const StatusColorsTheme({
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.info,
    required this.onInfo,
    required this.pending,
  });

  factory StatusColorsTheme.fromColorScheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return StatusColorsTheme(
      success: isDark ? AppColors.darkSuccess : AppColors.success,
      onSuccess: isDark ? AppColors.darkOnSuccess : AppColors.onSuccess,
      warning: isDark ? AppColors.darkWarning : AppColors.warning,
      onWarning: AppColors.onWarning,
      info: isDark ? AppColors.darkInfo : AppColors.info,
      onInfo: isDark ? colorScheme.onPrimary : AppColors.onInfo,
      pending: isDark ? AppColors.darkPending : AppColors.warning,
    );
  }

  @override
  StatusColorsTheme copyWith({
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? info,
    Color? onInfo,
    Color? pending,
  }) {
    return StatusColorsTheme(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      pending: pending ?? this.pending,
    );
  }

  @override
  StatusColorsTheme lerp(ThemeExtension<StatusColorsTheme>? other, double t) {
    if (other is! StatusColorsTheme) {
      return this;
    }

    return StatusColorsTheme(
      success: Color.lerp(success, other.success, t) ?? success,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t) ?? onSuccess,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      onWarning: Color.lerp(onWarning, other.onWarning, t) ?? onWarning,
      info: Color.lerp(info, other.info, t) ?? info,
      onInfo: Color.lerp(onInfo, other.onInfo, t) ?? onInfo,
      pending: Color.lerp(pending, other.pending, t) ?? pending,
    );
  }
}
