import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/auth/presentation/providers/auth_providers.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
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

  try {
    final remoteUserId = resolveRemoteUserIdForConversation(
      conversationId,
      currentUserId,
    );
    final repository = ref.read(chatsRepositoryProvider);
    await repository.ensureE2eeSessionForContact(remoteUserId);
    return E2eeSessionUiStatus.ready;
  } on ArgumentError {
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

    final repository = ref.read(chatsRepositoryProvider);

    await repository.sendMessage(
      conversationId: conversationId,
      content: text,
    );
  }
}
