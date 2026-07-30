// lib/features/chats/presentation/providers/conversations_provider.dart

import 'dart:async';

import 'package:obywatel_plus/features/chats/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/chats/domain/models/conversation.dart';
import 'package:obywatel_plus/features/chats/domain/models/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'conversations_provider.g.dart';

@riverpod
class Conversations extends _$Conversations {
  StreamSubscription<Message>? _messageSubscription;

  @override
  Future<List<Conversation>> build() async {
    final repository = ref.watch(chatsRepositoryProvider);

    _messageSubscription?.cancel();
    _messageSubscription = repository.incomingMessagesStream.listen(
      _handleIncomingMessage,
    );
    ref.onDispose(() => _messageSubscription?.cancel());

    return repository.getConversations();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(chatsRepositoryProvider);
      return repository.getConversations();
    });
  }

  void _handleIncomingMessage(Message message) {
    final currentList = state.value;
    if (currentList == null) return;

    final index = currentList.indexWhere((c) => c.id == message.conversationId);
    if (index == -1) return;

    final targetConv = currentList[index];
    final updatedConv = Conversation(
      id: targetConv.id,
      type: targetConv.type,
      title: targetConv.title,
      lastSequence: targetConv.lastSequence,
      members: targetConv.members,
      messages: [message, ...(targetConv.messages ?? [])],
      updatedAt: message.createdAt,
    );

    final newList = List<Conversation>.from(currentList);
    newList.removeAt(index);
    newList.insert(0, updatedConv);

    state = AsyncValue.data(newList);
  }
}
