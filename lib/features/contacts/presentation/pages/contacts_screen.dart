import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/features/chats/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/contacts/data/repositories/contacts_repository_impl.dart';
import 'package:obywatel_plus/features/contacts/domain/models/contact.dart';
import 'package:obywatel_plus/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/add_contact_modal.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_contact_card.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_empty_state.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_error_view.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_online_section.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_search_delegate.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  final Set<String> _processingRequestIds = <String>{};

  void _openAddContactModal(BuildContext context) {
    showDialog(context: context, builder: (_) => const AddContactModal());
  }

  Future<void> _respondToRequest(Contact contact, bool accept) async {
    if (_processingRequestIds.contains(contact.id)) return;

    setState(() => _processingRequestIds.add(contact.id));

    try {
      final repository = ref.read(contactsRepositoryProvider);
      await repository.respondToRequest(contact.id, accept);

      if (accept) {
        final chatsRepository = ref.read(chatsRepositoryProvider);
        final title = contact.localAlias?.trim().isNotEmpty == true
            ? contact.localAlias!
            : contact.displayName;

        final conversationId = await chatsRepository.ensureConversationForContact(
          contact.contactUserId,
          title: title,
        );

        if (!mounted) return;

        context.push(
          '/chats/${Uri.encodeComponent(conversationId)}',
          extra: title,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            accept
                ? 'Zaproszenie zaakceptowane dla ${contact.displayName}'
                : 'Zaproszenie odrzucone dla ${contact.displayName}',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: accept ? Colors.green : Colors.orange,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nie udało się zaktualizować zaproszenia: $error'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _processingRequestIds.remove(contact.id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
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

    return Scaffold(
      backgroundColor: colorScheme.surface,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddContactModal(context),
        icon: const Icon(Icons.person_add),
        label: const Text('Dodaj kontakt'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: SafeArea(
        child: Center(
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
      ),
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
          SliverAppBar(
            floating: true,
            snap: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
              tooltip: 'Powrót do ekranu głównego',
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home');
                }
              },
            ),
            title: Text(
              'Kontakty (${contacts.length})',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: colorScheme.surface,
            actions: [
              IconButton(
                icon: Icon(Icons.search, color: colorScheme.onSurface),
                tooltip: 'Szukaj kontaktów',
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: ContactsSearchDelegate(contacts: contacts),
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
                  (context, index) {
                    final contact = pendingContacts[index];
                    final isBusy = _processingRequestIds.contains(contact.id);

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(contact.displayName.isNotEmpty ? contact.displayName[0].toUpperCase() : '?'),
                        ),
                        title: Text(contact.displayName),
                        subtitle: Text(contact.status),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton.icon(
                              onPressed: isBusy ? null : () => _respondToRequest(contact, true),
                              icon: const Icon(Icons.check),
                              label: const Text('Akceptuj'),
                            ),
                            TextButton.icon(
                              onPressed: isBusy ? null : () => _respondToRequest(contact, false),
                              icon: const Icon(Icons.close),
                              label: const Text('Odrzuć'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: ContactsContactCard(contact: contacts[index]),
                    ),
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
