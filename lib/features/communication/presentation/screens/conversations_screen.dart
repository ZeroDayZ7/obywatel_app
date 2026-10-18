import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/conversations_provider.dart';
import 'package:obywatel_plus/features/communication/presentation/screens/chat_room_screen.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/conversations/conversation_tile.dart';

class ConversationsScreen extends ConsumerStatefulWidget {
  const ConversationsScreen({super.key});

  @override
  ConsumerState<ConversationsScreen> createState() =>
      _ConversationsScreenState();
}

class _ConversationsScreenState extends ConsumerState<ConversationsScreen> {
  bool _selfConversationInitialized = false;

  Future<void> _initializeSelfConversation() async {
    if (_selfConversationInitialized) {
      return;
    }

    _selfConversationInitialized = true;
    await Future.microtask(() async {
      if (!mounted) {
        return;
      }
      await ref.read(chatsRepositoryProvider).ensureSelfConversation();
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeSelfConversation();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final conversationsState = ref.watch(conversationsProvider);

    return conversationsState.when(
      data: (conversations) {
        if (conversations.isEmpty) {
          return Center(
            child: Text(
              'Brak aktywnych konwersacji',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(conversationsProvider.notifier).refresh(),
          child: ListView.builder(
            key: const PageStorageKey('conversations-list'),
            padding: const EdgeInsets.all(12),
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return ConversationTile(
                key: ValueKey(conversation.id),
                conversation: conversation,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatRoomScreen(
                        conversationId: conversation.id,
                        title: conversation.title?.trim().isNotEmpty == true
                            ? conversation.title!
                            : 'Konwersacja #${conversation.id.trim().length <= 4 ? conversation.id.trim() : conversation.id.trim().substring(0, 4)}',
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
      loading: () =>
          Center(child: CircularProgressIndicator(color: colorScheme.primary)),
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
            FilledButton(
              onPressed: () =>
                  ref.read(conversationsProvider.notifier).refresh(),
              child: const Text('Spróbuj ponownie'),
            ),
          ],
        ),
      ),
    );
  }
}
