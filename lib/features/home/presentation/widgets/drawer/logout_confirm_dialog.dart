import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/design/widgets/ui/button.dart';

enum LogoutAction { logout, unpairAndReset }

class LogoutConfirmDialog extends StatefulWidget {
  const LogoutConfirmDialog({super.key});

  static Future<LogoutAction?> show(BuildContext context) {
    return showDialog<LogoutAction>(
      context: context,
      builder: (context) => const LogoutConfirmDialog(),
    );
  }

  @override
  State<LogoutConfirmDialog> createState() => _LogoutConfirmDialogState();
}

class _LogoutConfirmDialogState extends State<LogoutConfirmDialog> {
  bool _removeDeviceAndPin = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Text(LocaleKeys.drawer_logout_title.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LocaleKeys.drawer_logout_content.tr()),
          const SizedBox(height: 16),
          const Divider(),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _removeDeviceAndPin,
            activeColor: colorScheme.error,
            title: Text(
              LocaleKeys.drawer_remove_device_title.tr(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              LocaleKeys.drawer_remove_device_subtitle.tr(),
              style: const TextStyle(fontSize: 12),
            ),
            onChanged: (value) {
              setState(() {
                _removeDeviceAndPin = value ?? false;
              });
            },
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: AppButton(
                  label: LocaleKeys.common_cancel.tr(),
                  variant: AppButtonVariant.text,
                  onPressed: () => Navigator.of(context).pop(null),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  label: LocaleKeys.drawer_logout.tr(),
                  variant: AppButtonVariant.danger,
                  onPressed: () {
                    final action = _removeDeviceAndPin
                        ? LogoutAction.unpairAndReset
                        : LogoutAction.logout;
                    Navigator.of(context).pop(action);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
