import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/app/theme/theme_extensions.dart';
import 'package:obywatel_plus/features/communication/domain/contacts/contact.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/contacts_provider.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/add_contact_modal.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/contacts_contact_card.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/contacts_empty_state.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/contacts_error_view.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/contacts_online_section.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/contacts_search_delegate.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/contacts_settings_sheet.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/pending_contact_card.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  void _openAddContactModal(BuildContext context) {
    showDialog(context: context, builder: (_) => const AddContactModal());
  }

  void _openSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      builder: (_) => const ContactsSettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final acceptedContactsAsync = ref.watch(acceptedContactsProvider);
    final pendingContactsAsync = ref.watch(pendingContactsProvider);
    final isDesktop = MediaQuery.sizeOf(context).width > 800;

    ref.listen<AsyncValue<void>>(contactsSyncProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Błąd synchronizacji: ${next.error}'),
            backgroundColor: colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    final acceptedContacts = acceptedContactsAsync.maybeWhen(
      data: (contacts) => contacts,
      orElse: () => <Contact>[],
    );
    final pendingContacts = pendingContactsAsync.maybeWhen(
      data: (contacts) => contacts,
      orElse: () => <Contact>[],
    );

    return Stack(
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: acceptedContactsAsync.when(
              data: (_) => _buildContactsContent(
                context,
                ref,
                acceptedContacts,
                pendingContacts,
                isDesktop,
              ),
              loading: () => Center(
                child: CircularProgressIndicator(color: colorScheme.primary),
              ),
              error: (error, stack) => ContactsErrorView(error: error),
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton.extended(
            onPressed: () => _openAddContactModal(context),
            icon: const Icon(Icons.person_add),
            label: const Text('Dodaj kontakt'),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            heroTag: null,
          ),
        ),
      ],
    );
  }

  Widget _buildContactsContent(
    BuildContext context,
    WidgetRef ref,
    List<Contact> contacts,
    List<Contact> pendingContacts,
    bool isDesktop,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onlineContacts = contacts.where((c) => c.isOnline ?? false).toList();

    return RefreshIndicator(
      color: colorScheme.primary,
      backgroundColor: colorScheme.surfaceContainerHigh,
      onRefresh: () async {
        await ref.read(contactsSyncProvider.notifier).sync();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${contacts.length} trusted • ${onlineContacts.length} online • ${pendingContacts.length} pending',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.tune_rounded,
                          color: colorScheme.onSurface,
                        ),
                        tooltip: 'Ustawienia kontaktów',
                        onPressed: () => _openSettingsSheet(context),
                      ),
                      IconButton(
                        icon: Icon(Icons.search, color: colorScheme.onSurface),
                        tooltip: 'Szukaj kontaktów',
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: ContactsSearchDelegate(
                              contacts: contacts,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh, color: colorScheme.onSurface),
                        tooltip: 'Synchronizuj',
                        onPressed: () {
                          ref.read(contactsSyncProvider.notifier).sync();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (pendingContacts.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    Icon(Icons.mail_outline, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Zaproszenia oczekujące (${pendingContacts.length})',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      PendingContactCard(contact: pendingContacts[index]),
                  childCount: pendingContacts.length,
                ),
              ),
            ),
          ],
          if (contacts.isEmpty && pendingContacts.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: ContactsEmptyState(),
            )
          else ...[
            if (contacts.isNotEmpty) ...[
              if (onlineContacts.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Text(
                      'DOSTĘPNI TERAZ (${onlineContacts.length})',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
                ContactsOnlineSection(contacts: onlineContacts),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
              ],
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Text(
                    'MOJE KONTAKTY',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
            SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 24.0 : 8.0,
                  vertical: 4.0,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ContactsContactCard(contact: contacts[index]),
                    childCount: contacts.length,
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
