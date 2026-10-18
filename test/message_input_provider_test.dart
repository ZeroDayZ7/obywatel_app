import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/storage/local_attachment_store.dart';
import 'package:obywatel_plus/core/storage/local_attachment_store_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/data/dtos/attachment_dto.dart';
import 'package:obywatel_plus/features/communication/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/chats/conversation.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:obywatel_plus/features/communication/domain/outbox/outbox_event.dart';
import 'package:obywatel_plus/features/communication/domain/repositories/chats_repository.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/active_chat_provider.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/attachment_preview_provider.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/message_input_provider.dart';

class FakeSecureStorage extends SecureStorageService {
  final Map<String, String> values = {};

  FakeSecureStorage() : super(const FlutterSecureStorage(), AppLogger());

  @override
  Future<void> write({required String key, required String value}) async {
    values[key] = value;
  }

  @override
  Future<String?> read({required String key}) async => values[key];
}

class FakeChatsRepository implements ChatsRepository {
  final Map<String, Map<String, dynamic>> metadataByAttachment = {};
  final List<Map<String, dynamic>> sentMessages = [];

  @override
  Stream<List<Conversation>> watchConversations() => const Stream.empty();

  @override
  Stream<List<Message>> watchMessagesForConversation(String conversationId) =>
      const Stream.empty();

  @override
  Future<List<Conversation>> getConversations() async => const [];

  @override
  Future<String> resolvePeerUserIdForConversation(
    String conversationId,
  ) async => 'peer-user';

  @override
  Future<String> ensureSelfConversation() async => 'self';

  @override
  Future<String> ensureConversationForContact(
    String contactUserId, {
    String? title,
  }) async => 'conversation';

  @override
  Future<void> ensureE2eeSessionForContact(String contactUserId) async {}

  @override
  Future<List<Message>> getMessageHistory(
    String conversationId, {
    String? beforeId,
    int limit = 50,
  }) async => const [];

  @override
  Future<void> sendMessage({
    required String conversationId,
    required String content,
    String? attachmentId,
  }) async {
    sentMessages.add({
      'conversationId': conversationId,
      'content': content,
      'attachmentId': attachmentId,
    });
  }

  @override
  Future<Map<String, dynamic>?> getAttachmentMetadata(
    String attachmentId,
  ) async => metadataByAttachment[attachmentId];

  @override
  Future<void> saveAttachmentMetadata({
    required String attachmentId,
    String? messageId,
    String? originalFileName,
    String? mimeType,
    int sizeBytes = 0,
    String sha256 = '',
    String? localFilePath,
    String? thumbnailPath,
    String status = 'ready',
    bool isAvailableLocally = false,
    bool hasThumbnail = false,
  }) async {
    final existing = metadataByAttachment[attachmentId] ?? <String, dynamic>{};
    final merged = <String, dynamic>{...existing};

    if (localFilePath != null && localFilePath.trim().isNotEmpty) {
      merged['localFilePath'] = localFilePath;
    }
    if (thumbnailPath != null && thumbnailPath.trim().isNotEmpty) {
      merged['thumbnailPath'] = thumbnailPath;
    }
    if (status.trim().isNotEmpty) {
      merged['status'] = status;
    }
    merged['isAvailableLocally'] = isAvailableLocally;
    merged['hasThumbnail'] = hasThumbnail;

    metadataByAttachment[attachmentId] = merged;
  }

  @override
  Stream<Message> get incomingMessagesStream => const Stream.empty();

  @override
  Future<List<Message>> getPendingOutboxMessages() async => const [];

  @override
  Future<List<OutboxEvent>> getRetryEligibleOutboxEvents({
    DateTime? referenceTime,
  }) async => const [];

  @override
  Future<String?> getAttachmentKey(String attachmentId) async =>
      metadataByAttachment[attachmentId]?['attachmentKey'] as String?;

  @override
  Future<void> saveAttachmentKey({
    required String attachmentId,
    required String attachmentKey,
  }) async {
    final existing = metadataByAttachment[attachmentId] ?? <String, dynamic>{};
    metadataByAttachment[attachmentId] = {
      ...existing,
      'attachmentKey': attachmentKey,
    };
  }

  @override
  Future<void> deleteAttachmentKey(String attachmentId) async {
    final existing = metadataByAttachment[attachmentId];
    if (existing == null) {
      return;
    }
    existing.remove('attachmentKey');
  }

  @override
  Future<void> deleteInvalidOutboxEvents(List<String> ids) async {}

  @override
  Future<OutboxEvent?> getOutboxEventById(String id) async => null;

  @override
  Future<void> scheduleOutboxRetry(
    String id, {
    required int retryCount,
    DateTime? referenceTime,
  }) async {}

  @override
  Future<List<Map<String, dynamic>>> syncDeltaFromRemote({
    int lastKnownContactVersion = 0,
    int lastKnownMessageVersion = 0,
  }) async => const [];

  @override
  Future<void> clearSentOutboxMessages(List<String> messageIds) async {}

  @override
  Future<List<Conversation>> saveConversationsFromRemote(
    List<ConversationDto> dtos,
  ) async => const [];
}

class FakeChatsApiClient extends ChatsApiClient {
  FakeChatsApiClient({
    this.prepareResponse,
    this.finalizeResponse,
    this.prepareError,
    this.finalizeError,
  }) : super(
         ApiClient(
           dio: Dio(),
           storage: FakeSecureStorage(),
           logger: AppLogger(),
         ),
       );

  final AttachmentUploadResponseDto? prepareResponse;
  final AttachmentDto? finalizeResponse;
  final Object? prepareError;
  final Object? finalizeError;

  int prepareCalls = 0;
  int finalizeCalls = 0;
  int? lastFinalizeSize;
  String? lastFinalizeSha256;

  @override
  Future<AttachmentUploadResponseDto> prepareAttachmentUpload({
    required String conversationId,
    required String fileName,
    required String contentType,
    required int size,
  }) async {
    prepareCalls += 1;
    if (prepareError != null) {
      throw prepareError!;
    }
    return prepareResponse ??
        AttachmentUploadResponseDto(
          attachment: AttachmentDto(
            id: 'prep-123',
            userId: 'user-1',
            fileKey: 'key-1',
            originalName: fileName,
            contentType: contentType,
            size: size,
            status: 'uploaded',
          ),
          uploadUrl: 'http://127.0.0.1:1/upload',
          expiresAt: DateTime.now().add(const Duration(minutes: 5)),
        );
  }

  @override
  Future<AttachmentDto> finalizeAttachmentUpload({
    required String attachmentId,
    required int size,
    String? sha256,
    Map<String, dynamic>? metadata,
  }) async {
    finalizeCalls += 1;
    lastFinalizeSize = size;
    lastFinalizeSha256 = sha256;
    if (finalizeError != null) {
      throw finalizeError!;
    }
    return finalizeResponse ??
        AttachmentDto(
          id: attachmentId,
          userId: 'user-1',
          fileKey: 'file-key',
          originalName: 'image.png',
          contentType: 'image/png',
          size: size,
          sha256: sha256,
          status: 'ready',
          metadata: metadata ?? const {},
        );
  }
}

class FakeActiveChat extends ActiveChat {
  static final List<Map<String, dynamic>> sentMessages = [];

  @override
  Stream<List<Message>> build(String conversationId) => const Stream.empty();

  @override
  Future<void> sendMessage(String text, {String? attachmentId}) async {
    sentMessages.add({'text': text, 'attachmentId': attachmentId});
  }
}

ProviderContainer createMessageInputContainer({
  required FakeChatsApiClient apiClient,
  required FakeChatsRepository repository,
  required FakeSecureStorage secureStorage,
  required String conversationId,
}) {
  return ProviderContainer(
    overrides: [
      chatsApiClientProvider.overrideWithValue(apiClient),
      chatsRepositoryProvider.overrideWithValue(repository),
      secureStorageProvider.overrideWith((ref) => secureStorage),
      localAttachmentStoreProvider.overrideWithValue(LocalAttachmentStore()),
      activeChatProvider(conversationId).overrideWith(() => FakeActiveChat()),
    ],
  );
}

class MockUploadHttpClientAdapter implements HttpClientAdapter {
  const MockUploadHttpClientAdapter({this.failWithTimeout = false});

  final bool failWithTimeout;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<dynamic>? cancelFuture,
  ) async {
    if (failWithTimeout) {
      throw TimeoutException('upload timeout');
    }

    return ResponseBody.fromString(
      'ok',
      200,
      headers: {
        'content-type': ['application/octet-stream'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FakeActiveChat.sentMessages.clear();
  });

  test('ActiveChat.sendMessage can still send after provider disposal', () async {
    final repo = FakeChatsRepository();
    final container = ProviderContainer(
      overrides: [
        chatsRepositoryProvider.overrideWithValue(repo),
      ],
    );

    final notifier = container.read(activeChatProvider('room-disposed').notifier);
    container.dispose();

    await expectLater(
      notifier.sendMessage('hello from disposed provider'),
      completes,
    );
    expect(repo.sentMessages, isNotEmpty);
  });

  group('Attachment integrity validation', () {
    test('accepts matching plaintext hash and size metadata', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final metadata = {
        'sha256': sha256.convert(bytes).toString(),
        'size': bytes.length,
      };

      expect(
        () => validateAttachmentIntegrity(bytes: bytes, metadata: metadata),
        returnsNormally,
      );
    });

    test('rejects mismatched SHA-256', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final metadata = {
        'sha256': sha256.convert(Uint8List.fromList([9, 9, 9])).toString(),
        'size': bytes.length,
      };

      expect(
        () => validateAttachmentIntegrity(bytes: bytes, metadata: metadata),
        throwsA(isA<AttachmentIntegrityException>()),
      );
    });

    test('rejects mismatched size', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final metadata = {
        'sha256': sha256.convert(bytes).toString(),
        'size': bytes.length + 1,
      };

      expect(
        () => validateAttachmentIntegrity(bytes: bytes, metadata: metadata),
        throwsA(isA<AttachmentIntegrityException>()),
      );
    });

    test('rejects missing SHA-256 metadata', () {
      final bytes = Uint8List.fromList([1, 2, 3]);

      expect(
        () => validateAttachmentIntegrity(
          bytes: bytes,
          metadata: const {'size': 3},
        ),
        throwsA(isA<AttachmentIntegrityException>()),
      );
    });

    test(
      'finalizes upload with ciphertext hash and keeps plaintext hash for local validation',
      () async {
        final repo = FakeChatsRepository();
        final originalFactory = attachmentUploadClientFactory;
        addTearDown(() => attachmentUploadClientFactory = originalFactory);
        attachmentUploadClientFactory = ({required String contentType}) {
          final dio = Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              validateStatus: (status) =>
                  status != null && status >= 200 && status < 300,
              headers: {'Content-Type': contentType},
            ),
          );
          dio.httpClientAdapter = const MockUploadHttpClientAdapter();
          return dio;
        };

        final bytes = Uint8List.fromList([10, 20, 30, 40]);
        final apiClient = FakeChatsApiClient();
        final secureStorage = FakeSecureStorage();
        final container = createMessageInputContainer(
          apiClient: apiClient,
          repository: repo,
          secureStorage: secureStorage,
          conversationId: 'room- integrity',
        );
        final notifier = container.read(
          messageInputProvider('room- integrity').notifier,
        );

        await notifier.setAttachmentSelection(
          fileName: 'file.bin',
          bytes: bytes,
          mimeType: 'application/octet-stream',
        );

        final sent = await notifier.sendCurrentMessage();

        expect(sent, isTrue);
        expect(apiClient.lastFinalizeSize, bytes.length);
        expect(apiClient.lastFinalizeSha256, isNotNull);
        expect(
          apiClient.lastFinalizeSha256,
          isNot(sha256.convert(bytes).toString()),
        );
        expect(apiClient.finalizeCalls, 1);
      },
    );
  });

  group('MessageInputProvider attachment retry semantics', () {
    tearDown(() {
      FakeActiveChat.sentMessages.clear();
    });

    test(
      'sendCurrentMessage should only send uploadedAttachmentId after finalize',
      () async {
        final repo = FakeChatsRepository();
        final originalFactory = attachmentUploadClientFactory;
        addTearDown(() => attachmentUploadClientFactory = originalFactory);
        attachmentUploadClientFactory = ({required String contentType}) {
          final dio = Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              validateStatus: (status) =>
                  status != null && status >= 200 && status < 300,
              headers: {'Content-Type': contentType},
            ),
          );
          dio.httpClientAdapter = const MockUploadHttpClientAdapter();
          return dio;
        };
        final apiClient = FakeChatsApiClient(
          prepareResponse: AttachmentUploadResponseDto(
            attachment: AttachmentDto(
              id: 'prep-111',
              userId: 'user-1',
              fileKey: 'file-key',
              originalName: 'file.txt',
              contentType: 'text/plain',
              size: 3,
              status: 'uploaded',
            ),
            uploadUrl: 'https://example.test/upload',
            expiresAt: DateTime.now().add(const Duration(minutes: 5)),
          ),
          finalizeResponse: AttachmentDto(
            id: 'final-111',
            userId: 'user-1',
            fileKey: 'file-key',
            originalName: 'file.txt',
            contentType: 'text/plain',
            size: 3,
            status: 'ready',
          ),
        );
        final secureStorage = FakeSecureStorage();
        final container = createMessageInputContainer(
          apiClient: apiClient,
          repository: repo,
          secureStorage: secureStorage,
          conversationId: 'room-1',
        );

        final notifier = container.read(
          messageInputProvider('room-1').notifier,
        );
        await notifier.setAttachmentSelection(
          fileName: 'file.txt',
          bytes: Uint8List.fromList([1, 2, 3]),
          mimeType: 'text/plain',
        );

        await repo.saveAttachmentKey(
          attachmentId: 'prep-111',
          attachmentKey: base64Encode(
            Uint8List.fromList(List<int>.filled(32, 7)),
          ),
        );
        notifier.state = notifier.state.copyWith(
          attachment: PendingAttachment(
            fileName: 'file.txt',
            bytes: Uint8List.fromList([1, 2, 3]),
            mimeType: 'text/plain',
            isImage: false,
          ),
          preparedAttachmentId: 'prep-111',
          uploadUrl: 'https://example.test/upload',
          uploadedAttachmentId: null,
        );

        final sent = await notifier.sendCurrentMessage();

        expect(sent, isTrue);
        expect(apiClient.prepareCalls, 0);
        expect(apiClient.finalizeCalls, 1);
        expect(FakeActiveChat.sentMessages.single['attachmentId'], 'final-111');
      },
    );

    test(
      'retry should reuse prepared attachment and not create a new attachment after timeout',
      () async {
        final repo = FakeChatsRepository();
        final originalFactory = attachmentUploadClientFactory;
        addTearDown(() => attachmentUploadClientFactory = originalFactory);
        attachmentUploadClientFactory = ({required String contentType}) {
          final dio = Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              validateStatus: (status) =>
                  status != null && status >= 200 && status < 300,
              headers: {'Content-Type': contentType},
            ),
          );
          dio.httpClientAdapter = const MockUploadHttpClientAdapter(
            failWithTimeout: true,
          );
          return dio;
        };
        final apiClient = FakeChatsApiClient(
          finalizeError: TimeoutException('finalize timeout'),
        );
        final secureStorage = FakeSecureStorage();
        final container = createMessageInputContainer(
          apiClient: apiClient,
          repository: repo,
          secureStorage: secureStorage,
          conversationId: 'room-1',
        );

        final notifier = container.read(
          messageInputProvider('room-1').notifier,
        );
        await notifier.setAttachmentSelection(
          fileName: 'file.txt',
          bytes: Uint8List.fromList([1, 2, 3]),
          mimeType: 'text/plain',
        );
        await repo.saveAttachmentKey(
          attachmentId: 'prep-222',
          attachmentKey: base64Encode(
            Uint8List.fromList(List<int>.filled(32, 9)),
          ),
        );
        notifier.state = notifier.state.copyWith(
          attachment: PendingAttachment(
            fileName: 'file.txt',
            bytes: Uint8List.fromList([1, 2, 3]),
            mimeType: 'text/plain',
            isImage: false,
          ),
          preparedAttachmentId: 'prep-222',
          uploadUrl: 'http://127.0.0.1:1/upload',
          uploadedAttachmentId: null,
        );

        final firstAttempt = await notifier.sendCurrentMessage();
        expect(firstAttempt, isFalse);
        expect(apiClient.finalizeCalls, 1);

        final secondAttempt = await notifier.sendCurrentMessage();
        expect(secondAttempt, isFalse);
        expect(apiClient.prepareCalls, 0);
        expect(apiClient.finalizeCalls, 2);
      },
    );

    test(
      'sendCurrentMessage should fail when finalizeAttachmentUpload throws',
      () async {
        final repo = FakeChatsRepository();
        final originalFactory = attachmentUploadClientFactory;
        addTearDown(() => attachmentUploadClientFactory = originalFactory);
        attachmentUploadClientFactory = ({required String contentType}) {
          final dio = Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              validateStatus: (status) =>
                  status != null && status >= 200 && status < 300,
              headers: {'Content-Type': contentType},
            ),
          );
          dio.httpClientAdapter = const MockUploadHttpClientAdapter();
          return dio;
        };
        final apiClient = FakeChatsApiClient(
          prepareResponse: AttachmentUploadResponseDto(
            attachment: AttachmentDto(
              id: 'prep-333',
              userId: 'user-1',
              fileKey: 'file-key',
              originalName: 'file.pdf',
              contentType: 'application/pdf',
              size: 3,
              status: 'uploaded',
            ),
            uploadUrl: 'http://127.0.0.1:1/upload',
            expiresAt: DateTime.now().add(const Duration(minutes: 5)),
          ),
          finalizeError: TimeoutException('finalize failed'),
        );
        final secureStorage = FakeSecureStorage();
        final container = createMessageInputContainer(
          apiClient: apiClient,
          repository: repo,
          secureStorage: secureStorage,
          conversationId: 'room-1',
        );

        final notifier = container.read(
          messageInputProvider('room-1').notifier,
        );
        await notifier.setAttachmentSelection(
          fileName: 'file.pdf',
          bytes: Uint8List.fromList([9, 8, 7]),
          mimeType: 'application/pdf',
        );

        final sent = await notifier.sendCurrentMessage();

        expect(sent, isFalse);
        expect(FakeActiveChat.sentMessages, isEmpty);
        expect(
          notifier.state.errorMessage,
          'Nie udało się wysłać załącznika. Spróbuj ponownie.',
        );
      },
    );

    test(
      'sendCurrentMessage should send message after successful finalization',
      () async {
        final repo = FakeChatsRepository();
        final originalFactory = attachmentUploadClientFactory;
        addTearDown(() => attachmentUploadClientFactory = originalFactory);
        attachmentUploadClientFactory = ({required String contentType}) {
          final dio = Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              validateStatus: (status) =>
                  status != null && status >= 200 && status < 300,
              headers: {'Content-Type': contentType},
            ),
          );
          dio.httpClientAdapter = const MockUploadHttpClientAdapter();
          return dio;
        };
        final apiClient = FakeChatsApiClient(
          prepareResponse: AttachmentUploadResponseDto(
            attachment: AttachmentDto(
              id: 'prep-444',
              userId: 'user-1',
              fileKey: 'file-key',
              originalName: 'photo.png',
              contentType: 'image/png',
              size: 3,
              status: 'uploaded',
            ),
            uploadUrl: 'https://example.test/upload',
            expiresAt: DateTime.now().add(const Duration(minutes: 5)),
          ),
          finalizeResponse: AttachmentDto(
            id: 'final-444',
            userId: 'user-1',
            fileKey: 'final-key',
            originalName: 'photo.png',
            contentType: 'image/png',
            size: 3,
            status: 'ready',
          ),
        );
        final secureStorage = FakeSecureStorage();
        final container = createMessageInputContainer(
          apiClient: apiClient,
          repository: repo,
          secureStorage: secureStorage,
          conversationId: 'room-1',
        );

        final notifier = container.read(
          messageInputProvider('room-1').notifier,
        );
        await notifier.setAttachmentSelection(
          fileName: 'photo.png',
          bytes: Uint8List.fromList([1, 2, 3]),
          mimeType: 'image/png',
        );

        final sent = await notifier.sendCurrentMessage();

        expect(sent, isTrue);
        expect(FakeActiveChat.sentMessages.single['attachmentId'], 'final-444');
        expect(notifier.state, const MessageInputState());
      },
    );

    test(
      'should preserve existing local file and thumbnail metadata on retry',
      () async {
        final repo = FakeChatsRepository();
        final originalFactory = attachmentUploadClientFactory;
        addTearDown(() => attachmentUploadClientFactory = originalFactory);
        attachmentUploadClientFactory = ({required String contentType}) {
          final dio = Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              validateStatus: (status) =>
                  status != null && status >= 200 && status < 300,
              headers: {'Content-Type': contentType},
            ),
          );
          dio.httpClientAdapter = const MockUploadHttpClientAdapter();
          return dio;
        };
        await repo.saveAttachmentMetadata(
          attachmentId: 'prep-555',
          originalFileName: 'photo.png',
          mimeType: 'image/png',
          sizeBytes: 3,
          localFilePath: '/tmp/existing-file.png',
          thumbnailPath: '/tmp/existing-thumb.png',
          status: 'ready',
          isAvailableLocally: true,
          hasThumbnail: true,
        );
        final apiClient = FakeChatsApiClient(
          prepareResponse: AttachmentUploadResponseDto(
            attachment: AttachmentDto(
              id: 'prep-555',
              userId: 'user-1',
              fileKey: 'file-key',
              originalName: 'photo.png',
              contentType: 'image/png',
              size: 3,
              status: 'uploaded',
            ),
            uploadUrl: 'https://example.test/upload',
            expiresAt: DateTime.now().add(const Duration(minutes: 5)),
          ),
          finalizeResponse: AttachmentDto(
            id: 'final-555',
            userId: 'user-1',
            fileKey: 'final-key',
            originalName: 'photo.png',
            contentType: 'image/png',
            size: 3,
            status: 'ready',
          ),
        );
        final secureStorage = FakeSecureStorage();
        await repo.saveAttachmentKey(
          attachmentId: 'prep-555',
          attachmentKey: base64Encode(
            Uint8List.fromList(List<int>.filled(32, 7)),
          ),
        );
        final container = createMessageInputContainer(
          apiClient: apiClient,
          repository: repo,
          secureStorage: secureStorage,
          conversationId: 'room-1',
        );

        final notifier = container.read(
          messageInputProvider('room-1').notifier,
        );
        await notifier.setAttachmentSelection(
          fileName: 'photo.png',
          bytes: Uint8List.fromList([4, 5, 6]),
          mimeType: 'image/png',
        );
        notifier.state = notifier.state.copyWith(
          attachment: PendingAttachment(
            fileName: 'photo.png',
            bytes: Uint8List.fromList([4, 5, 6]),
            mimeType: 'image/png',
            isImage: true,
          ),
          preparedAttachmentId: 'prep-555',
          uploadUrl: 'https://example.test/upload',
          uploadedAttachmentId: null,
        );

        final sent = await notifier.sendCurrentMessage();

        expect(sent, isTrue);
        expect(
          repo.metadataByAttachment['final-555']?['localFilePath'],
          '/tmp/existing-file.png',
        );
        expect(
          repo.metadataByAttachment['final-555']?['thumbnailPath'],
          '/tmp/existing-thumb.png',
        );
      },
    );
  });
}
