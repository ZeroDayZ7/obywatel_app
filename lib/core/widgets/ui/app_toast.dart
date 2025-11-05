import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/theme/app_colors.dart';
import 'package:obywatel_plus/app/theme/app_text_styles.dart';

enum ToastType { success, error, info }

class AppToast {
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color bgColor;
    Icon? icon;

    switch (type) {
      case ToastType.success:
        bgColor = Colors.green;
        icon = const Icon(Icons.check_circle, color: Colors.white);
        break;
      case ToastType.error:
        bgColor = AppColors.error;
        icon = const Icon(Icons.error, color: Colors.white);
        break;
      case ToastType.info:
        bgColor = AppColors.accent;
        icon = const Icon(Icons.info, color: Colors.white);
        break;
    }

    final snackBar = SnackBar(
      duration: duration,
      backgroundColor: bgColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Row(
        children: [
          icon,
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.body.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
