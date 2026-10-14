import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/conversations_provider.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/private_space_provider.dart';
import 'package:obywatel_plus/features/communication/presentation/screens/chat_room_screen.dart';
import 'package:obywatel_plus/features/communication/presentation/screens/private_space_screen.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/private_space_card.dart';

class ConversationsScreen extends ConsumerStatefulWidget {
  const ConversationsScreen({super.key});

  @override
  ConsumerState<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends ConsumerState<ConversationsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(privateSpaceControllerProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final conversationsState = ref.watch(conversationsProvider);
    final privateSpaceState = ref.watch(privateSpaceControllerProvider);

    final privateSpacePreview = privateSpaceState.whenOrNull(
      data: (items) => items.isEmpty ? null : items.first.encryptedPayload,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: PrivateSpaceCard(
            preview: privateSpacePreview,
            isLoading: privateSpaceState.isLoading,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PrivateSpaceScreen(),
                ),
              );
            },
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
                onRefresh: () => ref.read(conversationsProvider.notifier).refresh(),
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

                    final lastActivity = conversation.updatedAt ?? DateTime.now();
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
                                  color: colorScheme.outlineVariant
                                      .withValues(alpha: 0.3),
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
                                              color: colorScheme.onSurfaceVariant,
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
