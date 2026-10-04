import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/auth/presentation/providers/auth_providers.dart';
import 'package:obywatel_plus/features/chats/application/e2ee_crypto_service.dart';
import 'package:obywatel_plus/features/chats/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/chats/domain/models/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_chat_provider.g.dart';

enum E2eeSessionUiStatus {
  initializing,
  ready,
  failed,
}

final chatE2eeSessionStatusProvider = FutureProvider.family<
    E2eeSessionUiStatus,
    String
>((ref, conversationId) async {
  final currentUserId = ref.watch(currentUserIdProvider);
  final remoteUserId = conversationId
      .split(':')
      .where((id) => id.trim().isNotEmpty && id != currentUserId)
      .firstOrNull ?? '';

  if (remoteUserId.isEmpty) {
    return E2eeSessionUiStatus.ready;
  }

  try {
    final repository = ref.read(chatsRepositoryProvider);
    await repository.ensureE2eeSessionForContact(remoteUserId);
    return E2eeSessionUiStatus.ready;
  } catch (_) {
    return E2eeSessionUiStatus.failed;
  }
});

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
