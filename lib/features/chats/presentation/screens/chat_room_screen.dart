import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/chats/presentation/providers/active_chat_provider.dart';
import 'package:obywatel_plus/features/chats/presentation/widgets/chat_app_bar.dart';
import 'package:obywatel_plus/features/chats/presentation/widgets/message_input_field.dart';
import 'package:obywatel_plus/features/chats/presentation/widgets/message_list.dart';

class ChatRoomScreen extends ConsumerWidget {
  final String conversationId;
  final String title;

  const ChatRoomScreen({
    super.key,
    required this.conversationId,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final chatState = ref.watch(activeChatProvider(conversationId));

    return Scaffold(
      appBar: ChatAppBar(title: title, subtitle: 'Zaszyfrowano E2EE'),
      body: Column(
        children: [
          Expanded(
            child: chatState.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return Center(
                    child: Text(
                      'Brak wiadomości. Rozpocznij konwersację!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  );
                }
                return MessageList(messages: messages);
              },
              loading: () => Center(
                child: CircularProgressIndicator(color: colorScheme.primary),
              ),
              error: (err, stack) => Center(
                child: Text(
                  'Błąd wczytywania czatu',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),
            ),
          ),
          MessageInputField(conversationId: conversationId),
        ],
      ),
    );
  }
}
