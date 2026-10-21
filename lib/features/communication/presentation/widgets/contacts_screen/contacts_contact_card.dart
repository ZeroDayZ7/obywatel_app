import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/communication/domain/contacts/contact.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/contact_details_sheet.dart';

class ContactsContactCard extends ConsumerWidget {
  final Contact contact;
  final bool showStatusIndicator;

  const ContactsContactCard({
    super.key,
    required this.contact,
    this.showStatusIndicator = true,
  });

  void _openDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ContactDetailsSheet(contact: contact),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final displayName = contact.localAlias?.trim().isNotEmpty == true
        ? contact.localAlias!
        : contact.displayName;
    final isOnline = contact.isOnline ?? false;
    final avatarUrl = contact.avatarUrl?.trim();

    // Kolor statusu (zielony dla online, stonowany szary dla offline)
    final statusColor = isOnline
        ? const Color(0xFF00E676)
        : colorScheme.outline.withValues(alpha: 0.6);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => _openDetails(context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // Awatar (Zdjęcie/Inicjał) ze wskaźnikiem obecności w rogu
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: colorScheme.primaryContainer,
                      backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                          ? NetworkImage(avatarUrl)
                          : null,
                      child: (avatarUrl == null || avatarUrl.isEmpty)
                          ? Text(
                              displayName.isNotEmpty
                                  ? displayName[0].toUpperCase()
                                  : '?',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : null,
                    ),

                    // Kropka statusu Online/Offline (placeholder z możliwością wyłączenia)
                    if (showStatusIndicator)
                      Positioned(
                        right: -1,
                        bottom: -1,
                        child: Container(
                          width: 13,
                          height: 13,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colorScheme.surfaceContainerHigh,
                              width: 2.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),

                // Nazwa i tekstowy podgląd statusu
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        displayName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isOnline ? 'Dostępny' : 'Niedostępny',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isOnline
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          fontWeight: isOnline ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),

                // Akcja podglądu szczegółów
                IconButton(
                  onPressed: () => _openDetails(context),
                  icon: Icon(
                    Icons.info_outline_rounded,
                    color: colorScheme.onSurfaceVariant,
                    size: 22,
                  ),
                  tooltip: 'Szczegóły kontaktu',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}