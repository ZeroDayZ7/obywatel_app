import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/communication/application/chat_sync_service.dart';
import 'package:obywatel_plus/features/communication/application/sync_status.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/active_chat_provider.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/chat_app_bar.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/conversation_options_menu.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messages/message_input_field.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messages/message_list.dart';

class ChatRoomScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final String title;

  const ChatRoomScreen({
    super.key,
    required this.conversationId,
    required this.title,
  });

  @override
  ConsumerState<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends ConsumerState<ChatRoomScreen> {
  late final ScrollController _scrollController;
  ProviderSubscription<AsyncValue<List<Message>>>? _chatSubscription;
  bool _isInitialScrollDone = false;
  bool _hasSeenAnyMessage = false;
  int _unreadCount = 0;
  Set<String> _lastVisibleMessageIds = <String>{};

  bool get _isNearBottom {
    if (!_scrollController.hasClients) {
      return true;
    }

    final position = _scrollController.position;
    return position.pixels <= 120;
  }

  void _setUnreadCount(int value) {
    if (!mounted || value == _unreadCount) {
      return;
    }

    setState(() {
      _unreadCount = value;
    });
  }

  void _scrollToBottom({bool animate = false}) {
    if (!_scrollController.hasClients) return;

    if (animate) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
      );
      return;
    }

    _scrollController.jumpTo(0);
  }

  void _scheduleScrollToBottom({bool animate = false}) {
    if (!mounted || !_scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollToBottom(animate: animate);
    });
  }

  void _handleMessageUpdate(List<Message> messages) {
    if (!mounted) {
      return;
    }

    if (messages.isEmpty) {
      if (_lastVisibleMessageIds.isNotEmpty || _unreadCount > 0) {
        _setUnreadCount(0);
      }

      if (_hasSeenAnyMessage) {
        _lastVisibleMessageIds = <String>{};
        _isInitialScrollDone = false;
      }

      return;
    }

    _hasSeenAnyMessage = true;
    final currentIds = messages.map((msg) => msg.id).toSet();

    if (!_isInitialScrollDone) {
      _isInitialScrollDone = true;
      _lastVisibleMessageIds = currentIds;
      _setUnreadCount(0);
      _scheduleScrollToBottom();
      return;
    }

    final newIds = currentIds.difference(_lastVisibleMessageIds);
    if (newIds.isEmpty) {
      _lastVisibleMessageIds = currentIds;
      return;
    }

    if (_isNearBottom) {
      _setUnreadCount(0);
      _scheduleScrollToBottom(animate: true);
    } else {
      _setUnreadCount(_unreadCount + newIds.length);
    }

    _lastVisibleMessageIds = currentIds;
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels <= 120 && _unreadCount > 0) {
      _setUnreadCount(0);
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);

    _chatSubscription = ref.listenManual<AsyncValue<List<Message>>>(
      activeChatProvider(widget.conversationId),
      (_, next) {
        next.whenData(_handleMessageUpdate);
      },
      fireImmediately: true,
    );

    Future.microtask(() async {
      if (!mounted) {
        return;
      }
      await ref
          .read(chatsRepositoryProvider)
          .markConversationAsRead(widget.conversationId);
    });
  }

  @override
  void dispose() {
    _chatSubscription?.close();
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final chatState = ref.watch(activeChatProvider(widget.conversationId));
    final syncStatus = ref.watch(chatSyncStatusControllerProvider);
    final e2eeStatus = ref.watch(
      chatE2eeSessionStatusProvider(widget.conversationId),
    );

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
        title: widget.title,
        subtitle: e2eeSubtitle,
        actions: [
          IconButton(
            onPressed: () async {
              await ref.read(chatSyncServiceProvider).forceSyncPendingData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Wymuszone odświeżenie czatu'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Force sync',
          ),
          ConversationOptionsMenu(onSelected: (_) {}),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: syncColor,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  syncMessage,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    letterSpacing: 0.4,
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

                return Stack(
                  children: [
                    MessageList(
                      messages: messages,
                      controller: _scrollController,
                    ),
                    if (_unreadCount > 0)
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: SafeArea(
                          child: InkWell(
                            onTap: () {
                              _setUnreadCount(0);
                              _scrollToBottom(animate: true);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Nowe wiadomości: $_unreadCount',
                                    style: theme.textTheme.labelMedium
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
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
          MessageInputField(conversationId: widget.conversationId),
        ],
      ),
    );
  }
}
