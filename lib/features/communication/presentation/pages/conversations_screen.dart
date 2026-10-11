import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/communication/application/chat_sync_service.dart';
import 'package:obywatel_plus/features/communication/application/sync_status.dart';
import 'package:obywatel_plus/features/communication/presentation/pages/chat_room_screen.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/conversations_provider.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/chat/messages_settings_sheet.dart';

class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final conversationsState = ref.watch(conversationsProvider);
    final syncStatus = ref.watch(chatSyncStatusControllerProvider);

    final syncColor = switch (syncStatus) {
      SyncStatus.idle => colorScheme.primary,
      SyncStatus.syncing => colorScheme.tertiary,
      SyncStatus.offline => colorScheme.error,
      SyncStatus.error => colorScheme.error,
    };

    final syncLabel = switch (syncStatus) {
      SyncStatus.idle => 'CONNECTED',
      SyncStatus.syncing => 'SYNCING',
      SyncStatus.offline => 'OFFLINE',
      SyncStatus.error => 'ERROR',
    };

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: syncColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'SYNC STATUS: $syncLabel',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                    builder: (_) => const MessagesSettingsSheet(),
                  );
                },
                icon: const Icon(Icons.tune_rounded),
                tooltip: 'Ustawienia wiadomości',
              ),
            ],
          ),
        ),
        Expanded(
          child: conversationsState.when(
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
                onRefresh: () =>
                    ref.read(conversationsProvider.notifier).refresh(),
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    final conversation = conversations[index];
                    var previewText = 'Brak podglądu';

                    for (final item in conversation.messages ?? const []) {
                      if (item != null) {
                        final message = item as dynamic;
                        final content = message.content?.toString();
                        if (content != null && content.isNotEmpty) {
                          previewText = content;
                          break;
                        }
                      }
                    }

                    final displayName =
                        (conversation.title != null &&
                            conversation.title!.isNotEmpty)
                        ? conversation.title!
                        : 'Konwersacja #${conversation.id.substring(0, 4)}';

                    final lastActivity =
                        conversation.updatedAt ?? DateTime.now();
                    final timestamp =
                        '${lastActivity.hour.toString().padLeft(2, '0')}:${lastActivity.minute.toString().padLeft(2, '0')}';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.35,
                          ),
                        ),
                      ),
                      child: InkWell(
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: colorScheme.outlineVariant.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                              ),
                              child: Icon(
                                conversation.type == 'group'
                                    ? Icons.group_outlined
                                    : Icons.person_outline,
                                color: colorScheme.onSurface,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          displayName,
                                          style: theme.textTheme.titleSmall
                                              ?.copyWith(
                                                color: colorScheme.onSurface,
                                                fontWeight: FontWeight.w700,
                                              ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        timestamp,
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'SESSION: ${conversation.id.substring(0, min(12, conversation.id.length))}',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.shield_outlined,
                                        size: 14,
                                        color: colorScheme.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          previewText,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodySmall
                                              ?.copyWith(
                                                color: colorScheme
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Text(
                                    'E2EE',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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
                  FilledButton(
                    onPressed: () =>
                        ref.read(conversationsProvider.notifier).refresh(),
                    child: const Text('Spróbuj ponownie'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
