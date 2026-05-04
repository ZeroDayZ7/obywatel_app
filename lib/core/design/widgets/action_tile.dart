import 'package:flutter/material.dart';

class ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isDanger;
  final bool isEnabled;
  final bool value;
  final ValueChanged<bool>? onToggle;
  final bool showArrow;

  const ActionTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isDanger = false,
    this.isEnabled = true,
    this.value = false,
    this.onToggle,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final disabledColor = theme.disabledColor;
    final activeColor = isDanger
        ? theme.colorScheme.error
        : theme.colorScheme.primary;

    final iconColor = isEnabled ? activeColor : disabledColor;
    final textColor = isEnabled
        ? (isDanger ? theme.colorScheme.error : theme.colorScheme.onSurface)
        : disabledColor;

    return ListTile(
      enabled: isEnabled,
      onTap: isEnabled
          ? (onToggle != null ? () => onToggle!(!value) : onTap)
          : null,
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!, style: TextStyle(color: textColor.withValues(alpha:0.7)))
          : null,
      trailing: _buildTrailing(theme),
    );
  }

  Widget? _buildTrailing(ThemeData theme) {
    if (onToggle != null) {
      return Switch.adaptive(
        value: value,
        onChanged: isEnabled ? onToggle : null,
      );
    }
    if (showArrow) {
      return Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: isEnabled ? null : theme.disabledColor,
      );
    }
    return null;
  }
}
