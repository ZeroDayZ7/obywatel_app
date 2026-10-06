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

    final isDestructiveActive = _removeDeviceAndPin;

    return AlertDialog(
      title: Text(LocaleKeys.drawer_logout_title.tr()),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LocaleKeys.drawer_logout_content.tr()),
          const SizedBox(height: 20),
          
          // --- ODŚWIEŻONY KAFELEK OPCJI ---
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isDestructiveActive
                  ? colorScheme.errorContainer.withValues(alpha:0.12)
                  : colorScheme.surfaceContainerHighest.withValues(alpha:0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDestructiveActive
                    ? colorScheme.error.withValues(alpha:0.4)
                    : colorScheme.outlineVariant.withValues(alpha:0.5),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CheckboxListTile(
                // Wewnętrzny padding rozwiązuje problem najechania tekstu na krawędzie
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                value: _removeDeviceAndPin,
                activeColor: colorScheme.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text(
                  LocaleKeys.drawer_remove_device_title.tr(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDestructiveActive
                        ? colorScheme.error
                        : colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  LocaleKeys.drawer_remove_device_subtitle.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _removeDeviceAndPin = value ?? false;
                  });
                },
              ),
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(
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
      ],
    );
  }
}