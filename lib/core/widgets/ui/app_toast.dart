import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/router/app_router_provider.dart'
    show rootNavigatorKey;
import 'package:obywatel_plus/app/theme/extensions/toast_theme.dart';

enum ToastType { success, error, info }

class AppToast {
  static void show(
    BuildContext? context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final ctx = context ?? rootNavigatorKey.currentContext;
    if (ctx == null) return;

    final theme = Theme.of(ctx);
    final toastTheme = theme.extension<ToastTheme>()!;

    Color bgColor;
    IconData icon;

    switch (type) {
      case ToastType.success:
        bgColor = toastTheme.successColor;
        icon = Icons.check_circle;
        break;
      case ToastType.error:
        bgColor = toastTheme.errorColor;
        icon = Icons.error;
        break;
      case ToastType.info:
        bgColor = toastTheme.infoColor;
        icon = Icons.info;
        break;
    }

    final snackBar = SnackBar(
      duration: duration,
      backgroundColor: bgColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: toastTheme.borderRadius),
      content: Row(
        children: [
          Icon(icon, color: toastTheme.textStyle.color),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: toastTheme.textStyle)),
        ],
      ),
    );

    ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
  }

  static void showGlobal(
    String message, {
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(null, message: message, type: type, duration: duration);
  }
}
