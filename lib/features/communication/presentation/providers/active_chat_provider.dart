import 'dart:async';

import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:obywatel_plus/features/communication/domain/repositories/chats_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'active_chat_provider.g.dart';

enum E2eeSessionUiStatus {
  initializing,
  ready,
  failed,
}

@riverpod
FutureOr<E2eeSessionUiStatus> chatE2eeSessionStatus(
  Ref ref,
  String conversationId,
) async {
  try {
    final repository = ref.read(chatsRepositoryProvider);
    final remoteUserId = await repository.resolvePeerUserIdForConversation(
      conversationId,
    );
    if (remoteUserId == conversationId.trim()) {
      return E2eeSessionUiStatus.ready;
    }
    await repository.ensureE2eeSessionForContact(remoteUserId);
    return E2eeSessionUiStatus.ready;
  } on ArgumentError {
    return E2eeSessionUiStatus.failed;
  } catch (_) {
    return E2eeSessionUiStatus.failed;
  }
}

@riverpod
class ActiveChat extends _$ActiveChat {
  late ChatsRepository _repository;

  @override
  Stream<List<Message>> build(String conversationId) {
    _repository = ref.watch(chatsRepositoryProvider);
    return _repository.watchMessagesForConversation(conversationId);
  }

  Future<void> sendMessage(String text, {String? attachmentId}) async {
    final normalizedText = text.trim();
    if (normalizedText.isEmpty && attachmentId == null) return;

    await _repository.sendMessage(
      conversationId: conversationId,
      content: normalizedText,
      attachmentId: attachmentId,
    );
  }
}
