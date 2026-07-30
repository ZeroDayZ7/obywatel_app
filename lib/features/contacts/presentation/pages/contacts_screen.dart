import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/features/contacts/domain/models/contact.dart';
import 'package:obywatel_plus/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_contact_card.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_empty_state.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_error_view.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_online_section.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_search_delegate.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final contactsAsync = ref.watch(acceptedContactsProvider);

    // Nasłuchiwanie błędów synchronizacji w tle
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

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 800;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: contactsAsync.when(
                  data: (contacts) =>
                      _buildContactsContent(context, ref, contacts, isDesktop),
                  loading: () => Center(
                    child: CircularProgressIndicator(
                      color: colorScheme.primary,
                    ),
                  ),
                  error: (error, stack) => ContactsErrorView(error: error),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContactsContent(
    BuildContext context,
    WidgetRef ref,
    List<Contact> contacts,
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
            // Strzałka powrotu przekierowująca do /home
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

          if (contacts.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: ContactsEmptyState(),
            )
          else ...[
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
                  'WSZYSTKIE KONTAKTY',
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
      ),
    );
  }
}
