import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/core_providers.dart' show apiClientProvider;

import '../application/session/session_service.dart';
import '../application/message/message_service.dart';

import '../crypto/message_crypto_service.dart';

import '../domain/repositories/chat_repository.dart';
import '../domain/repositories/message_repository.dart';

import '../data/remote/chat_api.dart';
import '../data/repositories/chat_repository_impl.dart';
import '../data/repositories/message_repository_impl.dart';

import '../application/chat/chat_controller.dart';

// ==========================================
// API
// ==========================================
final chatApiProvider = Provider<ChatApi>((ref) {
  final client = ref.watch(apiClientProvider);
  return ChatApi(client: client);
});

// ==========================================
// REPOSITORIES
// ==========================================
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(api: ref.watch(chatApiProvider));
});

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  return MessageRepositoryImpl();
});

// ==========================================
// CRYPTO
// ==========================================
final messageCryptoProvider = Provider<MessageCryptoService>((ref) {
  final session = ref.watch(
    sessionServiceProvider,
  ); // musisz mieć taki provider
  return MessageCryptoService(sharedSecretKey: session.sharedSecret);
});

// ==========================================
// MESSAGE SERVICE (opcjonalny wrapper)
// ==========================================
final messageServiceProvider = Provider<MessageService>((ref) {
  return MessageService(crypto: ref.watch(messageCryptoProvider));
});

// ==========================================
// CHAT CONTROLLER (manualny, nie AsyncNotifier)
// ==========================================
final chatControllerProvider = Provider.family<ChatController, String>((
  ref,
  chatId,
) {
  final controller = ChatController(
    chatRepository: ref.watch(chatRepositoryProvider),
    messageRepository: ref.watch(messageRepositoryProvider),
    crypto: ref.watch(messageCryptoProvider),
    sessionService: ref.watch(sessionServiceProvider),
  );

  controller.init(
    chatId,
  ); // ← od razu inicjalizujemy WebSocket + offline messages
  return controller;
});
