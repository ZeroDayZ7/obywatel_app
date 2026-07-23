import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/features/home/presentation/widgets/drawer/logout_confirm_dialog.dart';

class LogoutTile extends StatelessWidget {
  final ValueChanged<LogoutDialogResult>? onLogoutSelected;

  const LogoutTile({super.key, this.onLogoutSelected});

  Future<void> _handleTap(BuildContext context) async {
    final result = await showDialog<LogoutDialogResult>(
      context: context,
      builder: (context) => const LogoutConfirmDialog(),
    );

    if (result != null && result.confirmed) {
      onLogoutSelected?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.redAccent),
      title: Text(
        LocaleKeys.drawer_logout.tr(),
        style: const TextStyle(
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () => _handleTap(context),
    );
  }
}
