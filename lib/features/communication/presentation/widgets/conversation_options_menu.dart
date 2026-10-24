import 'package:flutter/material.dart';

enum ConversationMenuAction {
  search,
  multimedia,
  details,
  mute,
  markUnread,
  archive,
  security,
}

class ConversationOptionsMenu extends StatelessWidget {
  const ConversationOptionsMenu({super.key, this.onSelected});

  final ValueChanged<ConversationMenuAction>? onSelected;

  static const List<_ConversationMenuEntry> _entries = [
    _ConversationMenuEntry(
      action: ConversationMenuAction.search,
      label: 'Szukaj w rozmowie',
      icon: Icons.search_rounded,
    ),
    _ConversationMenuEntry(
      action: ConversationMenuAction.multimedia,
      label: 'Multimedia i załączniki',
      icon: Icons.photo_library_rounded,
    ),
    _ConversationMenuEntry(
      action: ConversationMenuAction.details,
      label: 'Szczegóły rozmowy',
      icon: Icons.info_outline_rounded,
    ),
    _ConversationMenuEntry.separator(),
    _ConversationMenuEntry(
      action: ConversationMenuAction.mute,
      label: 'Wycisz powiadomienia',
      icon: Icons.notifications_off_rounded,
    ),
    _ConversationMenuEntry(
      action: ConversationMenuAction.markUnread,
      label: 'Oznacz jako nieprzeczytane',
      icon: Icons.mark_email_unread_rounded,
    ),
    _ConversationMenuEntry(
      action: ConversationMenuAction.archive,
      label: 'Archiwizuj rozmowę',
      icon: Icons.archive_rounded,
    ),
    _ConversationMenuEntry.separator(),
    _ConversationMenuEntry(
      action: ConversationMenuAction.security,
      label: 'Bezpieczeństwo i szyfrowanie',
      icon: Icons.shield_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopupMenuButton<ConversationMenuAction>(
      tooltip: 'More options',
      clipBehavior: Clip.antiAlias,
      icon: Icon(Icons.more_vert_rounded, color: colorScheme.onSurface),
      iconSize: 22,
      elevation: 12,
      position: PopupMenuPosition.under,
      offset: const Offset(0, 10),
      color: colorScheme.surfaceContainerHigh,
      surfaceTintColor: colorScheme.primary,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.25),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.7),
          width: 1,
        ),
      ),
      constraints: const BoxConstraints(minWidth: 284),
      padding: EdgeInsets.zero,
      itemBuilder: (context) {
        final entries = <PopupMenuEntry<ConversationMenuAction>>[];
        for (final entry in _entries) {
          if (entry.isDivider) {
            entries.add(const PopupMenuDivider(height: 18));
            continue;
          }

          entries.add(
            PopupMenuItem<ConversationMenuAction>(
              value: entry.action!,
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(entry.icon, size: 20, color: colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return entries;
      },
      onSelected: (value) {
        onSelected?.call(value);
      },
    );
  }
}

class _ConversationMenuEntry {
  const _ConversationMenuEntry({
    required this.label,
    required this.icon,
    required this.action,
  }) : isDivider = false;

  const _ConversationMenuEntry.separator()
    : label = '',
      icon = null,
      action = null,
      isDivider = true;

  final String label;
  final IconData? icon;
  final ConversationMenuAction? action;
  final bool isDivider;
}
