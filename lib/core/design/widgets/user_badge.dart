import 'package:flutter/material.dart';

enum UserBadgeType { activity, supporter }

class UserBadge extends StatelessWidget {
  final UserBadgeType type;
  final String label;
  final String? subtitle;

  const UserBadge({
    super.key,
    required this.type,
    required this.label,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final config = _BadgeConfig.fromType(type, colorScheme);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: config.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: config.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 18, color: config.iconColor),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: config.textColor,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: config.textColor.withValues(alpha:0.7),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BadgeConfig {
  final Color background;
  final Color border;
  final Color textColor;
  final Color iconColor;
  final IconData icon;

  _BadgeConfig({
    required this.background,
    required this.border,
    required this.textColor,
    required this.iconColor,
    required this.icon,
  });

  factory _BadgeConfig.fromType(UserBadgeType type, ColorScheme scheme) {
    switch (type) {
      case UserBadgeType.activity:
        return _BadgeConfig(
          background: scheme.primaryContainer.withValues(alpha:0.6),
          border: scheme.primary.withValues(alpha:0.4),
          textColor: scheme.onPrimaryContainer,
          iconColor: scheme.primary,
          icon: Icons.military_tech,
        );

      case UserBadgeType.supporter:
        return _BadgeConfig(
          background: scheme.tertiaryContainer.withValues(alpha:0.6),
          border: scheme.tertiary.withValues(alpha:0.4),
          textColor: scheme.onTertiaryContainer,
          iconColor: scheme.tertiary,
          icon: Icons.workspace_premium,
        );
    }
  }
}
