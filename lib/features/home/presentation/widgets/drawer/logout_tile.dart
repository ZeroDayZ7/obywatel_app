import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';

class LogoutTile extends StatelessWidget {
  final VoidCallback onLogout;
  const LogoutTile({super.key, required this.onLogout});

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
      onTap: onLogout,
    );
  }
}
