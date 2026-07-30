import 'dart:async';

import 'package:obywatel_plus/features/chats/application/e2ee_crypto_service.dart';
import 'package:obywatel_plus/features/chats/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/chats/domain/models/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_chat_provider.g.dart';

@riverpod
class ActiveChat extends _$ActiveChat {
  StreamSubscription<Message>? _messageSubscription;

  @override
  Future<List<Message>> build(String conversationId) async {
    final repository = ref.watch(chatsRepositoryProvider);

    _messageSubscription?.cancel();
    _messageSubscription = repository.incomingMessagesStream.listen((msg) {
      if (msg.conversationId == conversationId) {
        _appendIncomingMessage(msg);
      }
    });
    ref.onDispose(() => _messageSubscription?.cancel());

    return repository.getMessageHistory(conversationId);
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final cryptoService = ref.read(e2eeCryptoServiceProvider);
    final repository = ref.read(chatsRepositoryProvider);

    final encrypted = await cryptoService.encryptMessage(conversationId, text);
    final payloadToSend = encrypted?.ciphertextBase64 ?? text;

    await repository.sendMessage(
      conversationId: conversationId,
      content: payloadToSend,
    );

    final optimisticMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: conversationId,
      senderId: 'my_user_id',
      content: text,
      isMine: true,
      createdAt: DateTime.now(),
    );

    _appendIncomingMessage(optimisticMessage);
  }

  void _appendIncomingMessage(Message message) {
    final currentMessages = state.value ?? [];
    state = AsyncValue.data([message, ...currentMessages]);
  }
}
