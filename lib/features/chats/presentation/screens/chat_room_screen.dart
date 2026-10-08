import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/communication/application/chat_sync_service.dart';
import 'package:obywatel_plus/features/communication/application/sync_status.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/active_chat_provider.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/chat_app_bar.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/message_input_field.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/message_list.dart';

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
            return 'Signal E2EE active';
          case E2eeSessionUiStatus.initializing:
            return 'E2EE handshake in progress';
          case E2eeSessionUiStatus.failed:
            return 'E2EE session compromised';
        }
      },
      loading: () => 'Session bootstrap pending',
      orElse: () => 'Session state unknown',
    );

    final syncMessage = switch (syncStatus) {
      SyncStatus.idle => 'Synced',
      SyncStatus.syncing => 'Syncing',
      SyncStatus.offline => 'Offline',
      SyncStatus.error => 'Sync error',
    };

    final syncColor = switch (syncStatus) {
      SyncStatus.idle => colorScheme.primary,
      SyncStatus.syncing => colorScheme.tertiary,
      SyncStatus.offline => colorScheme.error,
      SyncStatus.error => colorScheme.error,
    };

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: ChatAppBar(
        title: title,
        subtitle: e2eeSubtitle,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shield_outlined),
            tooltip: 'Session status',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
            tooltip: 'More options',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: syncColor,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'SYNC: $syncMessage',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 0.6,
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
                      'Brak wiadomości. Rozpocznij konwersację.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
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
