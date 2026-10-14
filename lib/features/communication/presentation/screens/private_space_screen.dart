import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:obywatel_plus/features/communication/data/dtos/private_space_item_dto.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/private_space_provider.dart';

class PrivateSpaceScreen extends ConsumerStatefulWidget {
  const PrivateSpaceScreen({super.key});

  @override
  ConsumerState<PrivateSpaceScreen> createState() => _PrivateSpaceScreenState();
}

class _PrivateSpaceScreenState extends ConsumerState<PrivateSpaceScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(privateSpaceControllerProvider.notifier).load();
    });
  }

  Future<void> _refresh() async {
    await ref.read(privateSpaceControllerProvider.notifier).refresh();
  }

  Future<void> _openEditor({PrivateSpaceItemDto? item}) async {
    final titleController = TextEditingController(text: item?.title ?? '');
    final contentController = TextEditingController(
      text: item?.encryptedPayload ?? '',
    );

    final shouldSave = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item == null ? 'Nowa notatka' : 'Edytuj notatkę',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Tytuł',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contentController,
                  minLines: 6,
                  maxLines: 12,
                  decoration: const InputDecoration(
                    labelText: 'Treść notatki',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(true),
                  icon: const Icon(Icons.save_rounded),
                  label: Text(item == null ? 'Zapisz notatkę' : 'Zapisz zmiany'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldSave != true) {
      return;
    }

    final trimmedTitle = titleController.text.trim();
    final trimmedContent = contentController.text.trim();
    if (trimmedContent.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Treść notatki nie może być pusta.')),
      );
      return;
    }

    try {
      if (item == null) {
        await ref.read(privateSpaceControllerProvider.notifier).createItem(
          title: trimmedTitle,
          content: trimmedContent,
        );
      } else {
        await ref.read(privateSpaceControllerProvider.notifier).updateItem(
          itemId: item.id,
          title: trimmedTitle,
          content: trimmedContent,
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            item == null ? 'Notatka została zapisana.' : 'Notatka została zaktualizowana.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nie udało się zapisać notatki: $error')),
      );
    }
  }

  Future<void> _deleteItem(String itemId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usunąć notatkę?'),
        content: const Text('Ta operacja usunie notatkę z prywatnej przestrzeni.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Anuluj'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Usuń'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    try {
      await ref.read(privateSpaceControllerProvider.notifier).deleteItem(itemId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notatka została usunięta.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nie udało się usunąć notatki: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(privateSpaceControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notatki dla siebie'),
        actions: [
          IconButton(
            onPressed: _refresh,
            tooltip: 'Odśwież',
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: state.when(
          data: (items) {
            if (items.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.note_alt_outlined,
                        size: 56,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Brak prywatnych notatek',
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tutaj przechowujesz własne teksty i pomysły, których nie chcesz mieszać z rozmowami.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: () => _openEditor(),
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Utwórz pierwszą notatkę'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final updated = item.updatedAt;
                  final formattedDate = DateFormat('dd.MM.yyyy, HH:mm').format(updated);

                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      title: Text(
                        item.title.trim().isEmpty ? 'Notatka' : item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            item.encryptedPayload,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Aktualizacja: $formattedDate',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Edytuj',
                            onPressed: () => _openEditor(item: item),
                            icon: const Icon(Icons.edit_rounded),
                          ),
                          IconButton(
                            tooltip: 'Usuń',
                            onPressed: () => _deleteItem(item.id),
                            icon: const Icon(Icons.delete_outline_rounded),
                          ),
                        ],
                      ),
                      onTap: () => _openEditor(item: item),
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline_rounded, size: 48, color: colorScheme.error),
                  const SizedBox(height: 12),
                  Text(
                    'Nie udało się pobrać notatek.',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => ref.read(privateSpaceControllerProvider.notifier).load(),
                    child: const Text('Spróbuj ponownie'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nowa notatka'),
      ),
    );
  }
}
