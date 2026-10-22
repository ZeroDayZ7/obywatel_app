// lib/features/chats/presentation/providers/conversations_provider.dart

import 'dart:async';

import 'package:obywatel_plus/core/notifications/feedback_service.dart';
import 'package:obywatel_plus/core/notifications/feedback_type.dart';
import 'package:obywatel_plus/core/notifications/notification_settings.dart';
import 'package:obywatel_plus/features/communication/application/chat_sync_service.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/chats/conversation.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_provider.g.dart';

@riverpod
class Conversations extends _$Conversations {
  StreamSubscription<Message>? _messageSubscription;
  StreamSubscription<List<Conversation>>? _conversationsSubscription;

  static bool _matchesLogicalMessage(Message left, Message right) {
    if (left.id == right.id) {
      return true;
    }

    if (left.conversationId != right.conversationId ||
        left.senderId != right.senderId) {
      return false;
    }

    final timeDelta = left.createdAt.difference(right.createdAt).abs();
    if (timeDelta > const Duration(seconds: 2)) {
      return false;
    }

    final leftText = left.content.trim();
    final rightText = right.content.trim();
    if (leftText.isNotEmpty && leftText == rightText) {
      return true;
    }

    final leftCipher = left.encryptedPayload.trim();
    final rightCipher = right.encryptedPayload.trim();
    if (leftCipher.isNotEmpty && leftCipher == rightCipher) {
      return true;
    }

    return false;
  }

  static Message _preferAuthoritativeMessage(Message current, Message next) {
    final currentIsDelivered = [
      'sent',
      'delivered',
      'read',
    ].contains(current.status);
    final nextIsDelivered = ['sent', 'delivered', 'read'].contains(next.status);

    if (currentIsDelivered != nextIsDelivered) {
      return nextIsDelivered ? next : current;
    }

    if (current.content.trim().isEmpty && next.content.trim().isNotEmpty) {
      return next;
    }

    if (next.createdAt.isAfter(current.createdAt)) {
      return next;
    }

    return current;
  }

  static List<Message?> mergeIncomingMessageIntoConversation(
    Conversation conversation,
    Message message,
  ) {
    final merged = <Message?>[
      ...(conversation.messages ?? const <Message?>[]),
      message,
    ];
    final deduped = <Message?>[];

    for (final entry in merged) {
      if (entry == null) {
        continue;
      }

      final existingIndex = deduped.indexWhere((candidate) {
        if (candidate == null) {
          return false;
        }
        return _matchesLogicalMessage(candidate, entry);
      });

      if (existingIndex >= 0) {
        deduped[existingIndex] = _preferAuthoritativeMessage(
          deduped[existingIndex] as Message,
          entry,
        );
      } else {
        deduped.add(entry);
      }
    }

    deduped.sort((a, b) {
      final left =
          a ??
          Message(
            id: '',
            conversationId: conversation.id,
            senderId: '',
            content: '',
            encryptedPayload: '',
            isMine: false,
            createdAt: DateTime.fromMillisecondsSinceEpoch(0),
          );
      final right =
          b ??
          Message(
            id: '',
            conversationId: conversation.id,
            senderId: '',
            content: '',
            encryptedPayload: '',
            isMine: false,
            createdAt: DateTime.fromMillisecondsSinceEpoch(0),
          );

      final timeCompare = left.createdAt.compareTo(right.createdAt);
      if (timeCompare != 0) return timeCompare;
      return left.id.compareTo(right.id);
    });

    return deduped;
  }

  @override
  Future<List<Conversation>> build() async {
    final repository = ref.watch(chatsRepositoryProvider);

    _messageSubscription?.cancel();
    _messageSubscription = repository.incomingMessagesStream.listen(
      _handleIncomingMessage,
    );

    final conversationsStream = repository.watchConversations();
    _conversationsSubscription?.cancel();
    _conversationsSubscription = conversationsStream.listen((items) {
      state = AsyncValue.data(items);
    });

    ref.onDispose(() {
      _messageSubscription?.cancel();
      _conversationsSubscription?.cancel();
    });

    return conversationsStream.first;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(chatsRepositoryProvider);
      final syncService = ref.read(chatSyncServiceProvider);
      await syncService.syncPendingData();
      return repository.watchConversations().first;
    });
  }

  void _handleIncomingMessage(Message message) {
    final currentList = state.value;
    if (currentList == null) return;

    final index = currentList.indexWhere((c) => c.id == message.conversationId);
    if (index == -1) return;

    final targetConv = currentList[index];
    final mergedMessages = mergeIncomingMessageIntoConversation(
      targetConv,
      message,
    );

    final updatedConv = Conversation(
      id: targetConv.id,
      type: targetConv.type,
      title: targetConv.title,
      lastSequence: targetConv.lastSequence,
      lastReadSequence: targetConv.lastReadSequence,
      unreadCount: targetConv.unreadCount,
      members: targetConv.members,
      messages: mergedMessages,
      updatedAt: message.createdAt,
    );

    final newList = List<Conversation>.from(currentList);
    newList.removeAt(index);
    newList.insert(0, updatedConv);

    state = AsyncValue.data(newList);

    if (!message.isMine) {
      ref.read(feedbackServiceProvider).trigger(
        FeedbackType.info,
        moduleId: NotificationModuleId.communication,
      );
    }
  }
}
