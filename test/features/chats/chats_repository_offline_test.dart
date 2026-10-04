import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/features/chats/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/chats/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/chats/data/dtos/message_dto.dart';
import 'package:obywatel_plus/features/chats/data/repositories/chats_repository_impl.dart';

void main() {
  late AppDatabase database;
  late AppLogger logger;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    logger = AppLogger();
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'repository should persist remote conversations to local db and expose them via stream',
    () async {
      final apiClient = ChatsApiClient(
        ApiClient(
          dio: Dio(),
          storage: SecureStorageService(
            const FlutterSecureStorage(),
            logger,
          ),
          logger: logger,
        ),
      );

      final repository = ChatsRepositoryImpl(apiClient, database, logger);

      await repository.saveConversationsFromRemote([
        ConversationDto(
          id: 'conv-1',
          type: 'direct',
          title: 'Alice',
          lastSequence: 2,
          members: const [
            ConversationMemberDto(
              id: 'member-1',
              conversationId: 'conv-1',
              userId: 'me',
              role: 'admin',
              lastReadSequence: 2,
            ),
          ],
          messages: [
            MessageDto(
              id: 'msg-1',
              conversationId: 'conv-1',
              senderId: 'alice',
              senderDeviceId: 'device-1',
              type: 'text',
              sequence: 1,
              version: 1,
              encryptedPayload: 'hello',
              createdAt: DateTime(2024, 1, 1, 10, 0),
            ),
          ],
          updatedAt: DateTime(2024, 1, 1, 10, 5),
        ),
      ]);

      final conversations = await repository.watchConversations().first;
      final firstConversation = conversations.first;
      final firstMessage = firstConversation.messages?.firstWhere((m) => m != null);

      expect(conversations, isNotEmpty);
      expect(firstConversation.id, 'conv-1');
      expect(firstConversation.messages, isNotEmpty);
      expect(firstMessage, isNotNull);
      expect(firstMessage!.content, 'hello');
    },
  );
}
