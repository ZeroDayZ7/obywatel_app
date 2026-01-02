import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/margins/app_margins.dart';

class SettingsCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool showArrow;
  final bool isDanger;
  final Widget? trailing;

  const SettingsCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.showArrow = false,
    this.isDanger = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;

    // Twoje kolory zależne od isDanger
    final iconColor = isDanger ? errorColor : Colors.blueAccent;
    final titleColor = isDanger ? errorColor : null;
    final subtitleColor = isDanger ? errorColor : Colors.grey;

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: ButtonMargins.medium,
          child: Row(
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                        fontSize: 16,
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: TextStyle(fontSize: 14, color: subtitleColor),
                      ),
                    ],
                  ],
                ),
              ),
              // Obsługa końcówki: trailing (np. przycisk wyloguj) lub strzałka
              if (trailing != null)
                trailing!
              else if (showArrow)
                const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
