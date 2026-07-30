import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/contacts/domain/models/contact.dart';
import 'package:obywatel_plus/features/contacts/presentation/providers/contacts_provider.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_contact_card.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_online_section.dart';
import 'package:obywatel_plus/features/contacts/presentation/widgets/contacts_screen/contacts_search_delegate.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final contactsAsync = ref.watch(acceptedContactsProvider);

    // Nasłuchiwanie błędów synchronizacji w tle (np. brak sieci, błąd API)
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
            // Skalowanie widoku dla wersji Windows/Desktop (max 1000px szerokości)
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
                  error: (error, stack) => _buildErrorView(context, ref, error),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Główny widok listy i sekcji kontaktów online
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
          // Pasek aplikacji z przyciskami szukania i odświeżania
          SliverAppBar(
            floating: true,
            snap: true,
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

          // Jeśli lista jest pusta – pokaż atrakcyjny Empty State
          if (contacts.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState(context, ref),
            )
          else ...[
            // Sekcja z kontaktami online (pokazuje się tylko jeśli ktoś jest online)
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

            // Nagłówek dla pełnej listy
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

            // Lista główna kontaktów z odpowiednim marginesem dla Windowsa
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

  /// Estetyczny widok w przypadku braku kontaktów w bazie
  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.people_outline_rounded,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Brak kontaktów',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Twój spis kontaktów jest pusty. Pociągnij w dół, aby zsynchronizować lub dodaj nowych znajomych.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                ref.read(contactsSyncProvider.notifier).sync();
              },
              icon: const Icon(Icons.sync),
              label: const Text('Zsynchronizuj teraz'),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widok błędu z możliwością ponowienia próby
  Widget _buildErrorView(BuildContext context, WidgetRef ref, Object error) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 56,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Nie udało się pobrać kontaktów',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.error,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () {
                ref.invalidate(acceptedContactsProvider);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Spróbuj ponownie'),
            ),
          ],
        ),
      ),
    );
  }
}
