import 'package:flutter/material.dart';

class ContactsSettingsSheet extends StatefulWidget {
  const ContactsSettingsSheet({super.key});

  @override
  State<ContactsSettingsSheet> createState() => _ContactsSettingsSheetState();
}

class _ContactsSettingsSheetState extends State<ContactsSettingsSheet> {
  bool autoSync = true;
  bool autoAcceptInvites = false;
  bool exportTrustState = true;
  bool blockListProtection = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'KONTAKT / SETTINGS',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  color: colorScheme.onSurface,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _SettingsToggle(
              title: 'Automatyczna synchronizacja kontaktów',
              subtitle: 'Sync registry + trust directory',
              value: autoSync,
              onChanged: (value) => setState(() => autoSync = value),
            ),
            _SettingsToggle(
              title: 'Automatyczne akceptowanie zaproszeń',
              subtitle: 'PreKeys + identity handshakes',
              value: autoAcceptInvites,
              onChanged: (value) => setState(() => autoAcceptInvites = value),
            ),
            _SettingsToggle(
              title: 'Eksport zaufanych fingerprintów',
              subtitle: 'Fallback backup / trusted identities',
              value: exportTrustState,
              onChanged: (value) => setState(() => exportTrustState = value),
            ),
            _SettingsToggle(
              title: 'Zarządzanie blokadami identyfikatorów',
              subtitle: 'Protected denylist / restricted IDs',
              value: blockListProtection,
              onChanged: (value) => setState(() => blockListProtection = value),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: colorScheme.primary,
            activeTrackColor: colorScheme.primary.withValues(alpha: 0.35),
          ),
        ],
      ),
    );
  }
}
