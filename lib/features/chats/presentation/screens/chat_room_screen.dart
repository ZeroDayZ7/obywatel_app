import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/chats/application/chat_sync_service.dart';
import 'package:obywatel_plus/features/chats/application/sync_status.dart';
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
    final syncStatus = ref.watch(chatSyncStatusControllerProvider);
    final e2eeStatus = ref.watch(chatE2eeSessionStatusProvider(conversationId));

    final e2eeSubtitle = e2eeStatus.maybeWhen(
      data: (status) {
        switch (status) {
          case E2eeSessionUiStatus.ready:
            return 'Zaszyfrowano E2EE';
          case E2eeSessionUiStatus.initializing:
            return 'Inicjalizacja kluczy E2EE...';
          case E2eeSessionUiStatus.failed:
            return 'Błąd inicjalizacji kluczy E2EE';
        }
      },
      loading: () => 'Inicjalizacja kluczy E2EE...',
      orElse: () => 'Status E2EE nieznany',
    );

    return Scaffold(
      appBar: ChatAppBar(title: title, subtitle: e2eeSubtitle),
      body: Column(
        children: [
          if (syncStatus == SyncStatus.offline)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: colorScheme.errorContainer,
              child: Row(
                children: [
                  const Icon(Icons.signal_wifi_off_rounded, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Brak połączenia z serwerem. Tryb offline',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
