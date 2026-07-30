import 'package:flutter/material.dart';
import 'package:obywatel_plus/features/contacts/domain/models/contact.dart';

class ContactsContactCard extends StatelessWidget {
  final Contact contact;

  const ContactsContactCard({
    super.key,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: colorScheme.surfaceContainerHigh,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
          foregroundColor: colorScheme.primary,
          child: Text(
            contact.displayName.isNotEmpty ? contact.displayName[0].toUpperCase() : '?',
          ),
        ),
        title: Text(
          contact.displayName,
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          contact.status,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: colorScheme.onSurface.withValues(alpha: 0.4),
        ),
        onTap: () {
          // Navigacja do czatu z danym użytkownikiem
        },
      ),
    );
  }
}