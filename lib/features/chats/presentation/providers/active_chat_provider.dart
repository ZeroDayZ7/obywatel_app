import 'package:obywatel_plus/features/chats/application/e2ee_crypto_service.dart';
import 'package:obywatel_plus/features/chats/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/chats/domain/models/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_chat_provider.g.dart';

@riverpod
class ActiveChat extends _$ActiveChat {
  @override
  Stream<List<Message>> build(String conversationId) {
    final repository = ref.watch(chatsRepositoryProvider);
    return repository.watchMessagesForConversation(conversationId);
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final cryptoService = ref.read(e2eeCryptoServiceProvider);
    final repository = ref.read(chatsRepositoryProvider);

    final encrypted = await cryptoService.encryptMessage(conversationId, text);

    await repository.sendMessage(
      conversationId: conversationId,
      content: encrypted.ciphertextBase64,
    );
  }
}
