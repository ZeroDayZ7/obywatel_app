import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/features/chats/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/contacts/domain/models/contact.dart';

class ContactsContactCard extends ConsumerWidget {
  final Contact contact;

  const ContactsContactCard({
    super.key,
    required this.contact,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          contact.localAlias?.trim().isNotEmpty == true
              ? contact.localAlias!
              : contact.displayName,
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
        onTap: () async {
          try {
            final repository = ref.read(chatsRepositoryProvider);
            final conversationTitle = contact.localAlias?.trim().isNotEmpty == true
                ? contact.localAlias!
                : contact.displayName;

            final conversationId = await repository.ensureConversationForContact(
              contact.contactUserId,
              title: conversationTitle,
            );

            if (!context.mounted) return;

            context.push(
              '/chats/${Uri.encodeComponent(conversationId)}',
              extra: conversationTitle,
            );
          } catch (error) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Nie udało się otworzyć czatu: $error'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
      ),
    );
  }
}