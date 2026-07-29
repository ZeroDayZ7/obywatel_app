import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_controller.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/drawer/logout_confirm_dialog.dart';

class LogoutTile extends ConsumerWidget {
  final VoidCallback? onTap;

  const LogoutTile({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        hoverColor: errorColor.withValues(alpha: 0.08),
        splashColor: errorColor.withValues(alpha: 0.12),
        focusColor: errorColor.withValues(alpha: 0.12),
        leading: Icon(Icons.logout_rounded, color: errorColor),
        title: Text(
          LocaleKeys.common_logout.tr(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: errorColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: onTap ?? () => unwrapAndHandleLogout(context, ref),
      ),
    );
  }
}

Future<void> unwrapAndHandleLogout(BuildContext context, WidgetRef ref) async {
  final action = await LogoutConfirmDialog.show(context);
  if (action == null || !context.mounted) return;

  final authController = ref.read(authControllerProvider.notifier);

  switch (action) {
    case LogoutAction.unpairAndReset:
      await authController.unpairAndReset();
      break;
    case LogoutAction.logout:
      await authController.logout();
      break;
  }
}
