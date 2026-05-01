import 'package:flutter/material.dart';

class AppSwitch extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final IconData? leadingIcon;
  final bool isEnabled;
  final bool useCard;

  const AppSwitch({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.leadingIcon,
    this.isEnabled = true,
    this.useCard = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content = SwitchListTile(
      secondary: leadingIcon != null
          ? Icon(
              leadingIcon,
              color: isEnabled
                  ? theme.colorScheme.primary
                  : theme.disabledColor,
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isEnabled ? null : theme.disabledColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(color: theme.disabledColor, fontSize: 12),
            )
          : null,
      value: value,
      onChanged: isEnabled ? onChanged : null,
      activeThumbColor: theme.colorScheme.primary,
      contentPadding: useCard
          ? const EdgeInsets.symmetric(horizontal: 8)
          : EdgeInsets.zero,
    );

    if (useCard) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: content,
      );
    }

    return content;
  }
}
