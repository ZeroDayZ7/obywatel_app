import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/conversations_provider.dart';

class GroupsSection extends ConsumerWidget {
  const GroupsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(conversationsProvider);

    return state.when(
      data: (conversations) {
        final groups = conversations
            .where((conversation) => conversation.type == 'group')
            .toList();

        if (groups.isEmpty) {
          return const GroupEmptyState();
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final conversation = groups[index];
            final title = (conversation.title ?? '').trim();
            final safeTitle = title.isNotEmpty
                ? title
                : conversation.id.trim().isNotEmpty
                ? 'Grupa ${conversation.id.trim().substring(0, conversation.id.trim().length > 4 ? 4 : conversation.id.trim().length)}'
                : 'Grupa';
            final memberCount = conversation.members.length;

            return Card(
              child: ListTile(
                enabled: false,
                leading: CircleAvatar(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.group_rounded,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                title: Text(safeTitle),
                subtitle: Text(
                  memberCount > 0
                      ? '$memberCount uczestników'
                      : 'Brak uczestników',
                ),
                trailing: const Icon(Icons.info_outline_rounded),
              ),
            );
          },
          separatorBuilder: (_, _) => const SizedBox(height: 8),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text('Nie udało się pobrać grup: $error'),
        ),
      ),
    );
  }
}

class GroupEmptyState extends StatelessWidget {
  const GroupEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_work_rounded,
              size: 56,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Brak dostępnych grup',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Obecna integracja backendowa nie udostępnia jeszcze obsługi grup.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Funkcja będzie dostępna po uruchomieniu pełnej obsługi backendu.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
