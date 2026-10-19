import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/features/auth/presentation/providers/auth_providers.dart';
import 'package:obywatel_plus/features/communication/application/contact_identity_verification_service.dart';
import 'package:obywatel_plus/features/communication/application/contacts_service.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/contacts/contact.dart';

class ContactDetailsSheet extends ConsumerWidget {
  final Contact contact;

  const ContactDetailsSheet({super.key, required this.contact});

  Future<void> _openSecureChat(BuildContext context, WidgetRef ref) async {
    try {
      final currentUserId = ref.read(currentUserIdProvider);
      final peerUserId = contact.peerUserIdForCurrentUser(currentUserId);
      final repository = ref.read(chatsRepositoryProvider);
      final conversationId = await repository.ensureConversationForContact(
        peerUserId,
        title: contact.localAlias?.trim().isNotEmpty == true
            ? contact.localAlias!
            : contact.displayName,
      );

      if (!context.mounted) return;
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      if (!context.mounted) return;

      context.push(
        '/chats/${Uri.encodeComponent(conversationId)}',
        extra: contact.localAlias?.trim().isNotEmpty == true
            ? contact.localAlias!
            : contact.displayName,
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nie udało się otworzyć bezpiecznego czatu: $error'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _updateAlias(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController(text: contact.localAlias ?? '');
    final newAlias = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Zmień lokalny alias'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Wpisz alias kontaktu'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Anuluj'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(controller.text),
              child: const Text('Zapisz'),
            ),
          ],
        );
      },
    );

    if (newAlias == null || !context.mounted) {
      return;
    }

    final alias = newAlias.trim();
    if (alias.isEmpty) {
      return;
    }

    await ref
        .read(contactsServiceProvider)
        .updateLocalAlias(contact.contactUserId, alias);

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final verificationAsync = ref.watch(
      contactIdentityVerificationProvider(contact.contactUserId),
    );
    final verification = verificationAsync.maybeWhen(
      data: (state) => state,
      orElse: () => const ContactIdentityVerificationState(
        status: ContactIdentityVerificationStatus.unknown,
      ),
    );

    final statusTitle = switch (verification.status) {
      ContactIdentityVerificationStatus.unknown =>
        'Brak znanej tożsamości Signal',
      ContactIdentityVerificationStatus.unverified =>
        'Tożsamość znana, ale nieweryfikowana',
      ContactIdentityVerificationStatus.verified =>
        'Tożsamość zweryfikowana ręcznie',
      ContactIdentityVerificationStatus.changed =>
        'Tożsamość kontaktu zmieniła się',
    };
    final statusDescription = switch (verification.status) {
      ContactIdentityVerificationStatus.unknown =>
        'Klucz tożsamości nie jest jeszcze znany dla tego urządzenia Signal. Sesja musi zostać zainicjalizowana, a następnie zrobiona jest ręczna weryfikacja.',
      ContactIdentityVerificationStatus.unverified =>
        'Konieczne jest ręczne potwierdzenie klucza kontaktu, ponieważ odczytano go z witryny Signal bez lokalnej weryfikacji.',
      ContactIdentityVerificationStatus.verified =>
        'Ta tożsamość została potwierdzona lokalnie i jest powiązana z tym użytkownikiem i urządzeniem Signal.',
      ContactIdentityVerificationStatus.changed =>
        'Wykryto nowy klucz tożsamości. Poprzednie potwierdzenie jest nieważne do czasu ponownej weryfikacji.',
    };

    final fingerprint = verification.fingerprint;

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
                    'IDENTITY / CONTACT',
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      contact.displayName.isNotEmpty
                          ? contact.displayName[0].toUpperCase()
                          : '?',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contact.localAlias?.trim().isNotEmpty == true
                              ? contact.localAlias!
                              : contact.displayName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'USER ID: ${contact.contactUserId}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'DIGITAL TRUST',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusTitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (fingerprint != null) ...[
                    const SizedBox(height: 8),
                    SelectableText(
                      fingerprint,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 8),
                    Text(
                      'Brak znanego klucza Signal dla tego kontaktu.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    statusDescription,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _updateAlias(context, ref),
                icon: const Icon(Icons.edit_rounded),
                label: const Text('Zmień lokalny alias'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _openSecureChat(context, ref),
                icon: const Icon(Icons.lock_rounded),
                label: const Text('Otwórz bezpieczny czat'),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.verified_user_rounded),
                    label: Text(
                      verification.isVerified
                          ? 'Tożsamość zweryfikowana'
                          : 'Ręczna weryfikacja niedostępna',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
