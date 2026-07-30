// lib/features/chats/presentation/screens/conversations_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/chats/presentation/providers/conversations_provider.dart';
import 'package:obywatel_plus/features/chats/presentation/screens/chat_room_screen.dart';

class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final conversationsState = ref.watch(conversationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wiadomości'),
        automaticallyImplyLeading:
            true, 
      ),
      body: conversationsState.when(
        data: (conversations) {
          if (conversations.isEmpty) {
            return Center(
              child: Text(
                'Brak aktywnych konwersacji',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(conversationsProvider.notifier).refresh(),
            child: ListView.separated(
              itemCount: conversations.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
              itemBuilder: (context, index) {
                final conversation = conversations[index];

                // Pobieramy ostatnią wiadomość z listy, jeśli jest dostępna
                final lastMsg =
                    (conversation.messages != null &&
                        conversation.messages!.isNotEmpty)
                    ? conversation.messages!.first
                    : null;

                // Liczba nieprzeczytanych wiadomości (różnica między lastSequence a lastReadSequence)
                // Zakładamy pomocnicze wyliczenie lub domyślne 0
                final unreadCount =
                    conversation.lastSequence; // Możesz dostosować logikę

                final displayName =
                    (conversation.title != null &&
                        conversation.title!.isNotEmpty)
                    ? conversation.title!
                    : 'Konwersacja #${conversation.id.substring(0, 4)}';

                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ChatRoomScreen(
                          conversationId: conversation.id,
                          title: displayName,
                        ),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: colorScheme.surfaceContainerHigh,
                    child: Icon(
                      conversation.type == 'group'
                          ? Icons.group_outlined
                          : Icons.person_outline,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  title: Text(
                    displayName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: unreadCount > 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  subtitle: lastMsg != null
                      ? Text(
                          lastMsg.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        )
                      : null,
                  trailing: unreadCount > 0
                      ? Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$unreadCount',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null,
                );
              },
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Wystąpił błąd podczas ładowania wiadomości',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                ),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () =>
                    ref.read(conversationsProvider.notifier).refresh(),
                child: const Text('Spróbuj ponownie'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
