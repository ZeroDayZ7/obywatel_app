import 'package:dio/dio.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/crypto/drift_signal_protocol_store.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/communication/application/e2ee_crypto_service.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/contacts/contact.dart';

class ThrowingCryptoService extends E2eeCryptoService {
  ThrowingCryptoService(
    super.secureStorage,
    super.logger,
    super.apiClient,
    super.deviceInfoService,
    super.signalStore,
  );

  @override
  Future<void> ensureSessionForPeer(
    String remoteUserId, {
    int deviceId = 1,
    String? operationId,
  }) async {
    throw StateError('E2EE bootstrap should not run while accepting a contact');
  }
}

class CapturingCryptoService extends E2eeCryptoService {
  CapturingCryptoService(
    super.secureStorage,
    super.logger,
    super.apiClient,
    super.deviceInfoService,
    super.signalStore,
  );

  String? lastPeerUserId;
  String? lastPlaintext;

  @override
  Future<EncryptedData> encryptMessage(
    String remoteUserId,
    String plaintext, {
    String? operationId,
  }) async {
    lastPeerUserId = remoteUserId;
    lastPlaintext = plaintext;

    return const EncryptedData(
      ciphertextBase64: 'ciphertext-from-peer',
      nonceBase64: 'nonce',
      type: 3,
    );
  }
}

class FailingCryptoService extends E2eeCryptoService {
  FailingCryptoService(
    super.secureStorage,
    super.logger,
    super.apiClient,
    super.deviceInfoService,
    super.signalStore,
  );

  @override
  Future<EncryptedData> encryptMessage(
    String remoteUserId,
    String plaintext, {
    String? operationId,
  }) async {
    throw StateError('Encryption failed before any plaintext could be sent');
  }
}

class RecordingApiClient extends ApiClient {
  RecordingApiClient({required super.storage, required super.logger})
    : super(dio: Dio());

  final List<String> requests = <String>[];
  final List<Map<String, dynamic>> payloads = <Map<String, dynamic>>[];

  @override
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, String>? headers,
    Options? options,
  }) async {
    requests.add(path);
    payloads.add(Map<String, dynamic>.from(data as Map<String, dynamic>));
    return Response<dynamic>(
      data: {'ok': true},
      statusCode: 200,
      requestOptions: RequestOptions(path: path),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final secureStorageStore = <String, String>{};
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
        const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
        (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'read':
              final key = methodCall.arguments['key'] as String?;
              return secureStorageStore[key];
            case 'write':
              final key = methodCall.arguments['key'] as String?;
              final value = methodCall.arguments['value'] as String?;
              if (key != null && value != null) {
                secureStorageStore[key] = value;
              }
              return null;
            case 'delete':
              final key = methodCall.arguments['key'] as String?;
              if (key != null) {
                secureStorageStore.remove(key);
              }
              return null;
            case 'readAll':
              return Map<String, String>.from(secureStorageStore);
            case 'deleteAll':
              secureStorageStore.clear();
              return null;
            default:
              return null;
          }
        },
      );

  setUp(() {
    secureStorageStore.clear();
  });

  test(
    'ensureConversationForContact does not bootstrap E2EE session',
    () async {
      final logger = AppLogger();
      final db = AppDatabase(NativeDatabase.memory());
      final secureStorage = SecureStorageService(
        const FlutterSecureStorage(),
        logger,
      );
      final apiClient = ApiClient(
        dio: Dio(),
        storage: secureStorage,
        logger: logger,
      );
      final deviceInfoService = DeviceInfoService(logger);
      final signalStore = DriftSignalProtocolStore(db);
      final cryptoService = ThrowingCryptoService(
        secureStorage,
        logger,
        apiClient,
        deviceInfoService,
        signalStore,
      );
      final repository = ChatsRepositoryImpl(
        ChatsApiClient(
          ApiClient(dio: Dio(), storage: secureStorage, logger: logger),
        ),
        db,
        logger,
        'user-1',
        deviceInfoService,
        cryptoService,
      );

      final conversationId = await repository.ensureConversationForContact(
        'user-2',
        title: 'Piotr',
      );

      expect(conversationId, 'user-1:user-2');
      final conversations = await db.chatsDao.watchActiveConversations().first;
      expect(conversations, isNotEmpty);
    },
  );

  test(
    'Contact resolves peer user id for both owners and incoming/outgoing relations',
    () {
      const annaContact = Contact(
        id: 'contact-1',
        ownerId: 'a2f6b8c9-1122-4a55-8822-b98765432101',
        contactUserId: 'c3d4e5f6-3344-5b66-9933-a12345678902',
        status: 'accepted',
        direction: 'outgoing',
        displayName: 'Piotr',
      );
      const piotrContact = Contact(
        id: 'contact-2',
        ownerId: 'c3d4e5f6-3344-5b66-9933-a12345678902',
        contactUserId: 'a2f6b8c9-1122-4a55-8822-b98765432101',
        status: 'accepted',
        direction: 'incoming',
        displayName: 'Anna',
      );

      expect(
        annaContact.peerUserIdForCurrentUser(
          'a2f6b8c9-1122-4a55-8822-b98765432101',
        ),
        'c3d4e5f6-3344-5b66-9933-a12345678902',
      );
      expect(
        piotrContact.peerUserIdForCurrentUser(
          'c3d4e5f6-3344-5b66-9933-a12345678902',
        ),
        'a2f6b8c9-1122-4a55-8822-b98765432101',
      );
    },
  );

  test('peerUserIdForCurrentUser throws for non-participant', () {
    const contact = Contact(
      id: 'contact-x',
      ownerId: 'owner-1',
      contactUserId: 'owner-2',
      status: 'accepted',
      direction: 'incoming',
      displayName: 'Someone',
    );

    expect(
      () => contact.peerUserIdForCurrentUser('not-a-participant'),
      throwsArgumentError,
    );
  });

  test(
    'ensureConversationForContact produces canonical id identically for both participants',
    () async {
      final logger = AppLogger();
      final db1 = AppDatabase(NativeDatabase.memory());
      final db2 = AppDatabase(NativeDatabase.memory());
      final secureStorage = SecureStorageService(
        const FlutterSecureStorage(),
        logger,
      );
      final apiClient = ApiClient(
        dio: Dio(),
        storage: secureStorage,
        logger: logger,
      );
      final deviceInfoService = DeviceInfoService(logger);
      final cryptoService1 = ThrowingCryptoService(
        secureStorage,
        logger,
        apiClient,
        deviceInfoService,
        DriftSignalProtocolStore(db1),
      );
      final cryptoService2 = ThrowingCryptoService(
        secureStorage,
        logger,
        apiClient,
        deviceInfoService,
        DriftSignalProtocolStore(db2),
      );

      final annaRepo = ChatsRepositoryImpl(
        ChatsApiClient(apiClient),
        db1,
        logger,
        'anna',
        deviceInfoService,
        cryptoService1,
      );
      final piotrRepo = ChatsRepositoryImpl(
        ChatsApiClient(apiClient),
        db2,
        logger,
        'piotr',
        deviceInfoService,
        cryptoService2,
      );

      final idFromAnna = await annaRepo.ensureConversationForContact('piotr');
      final idFromPiotr = await piotrRepo.ensureConversationForContact('anna');

      expect(idFromAnna, idFromPiotr);
      expect(idFromAnna.split(':'), hasLength(2));
    },
  );

  test('resolveRemoteUserIdForConversation returns the other participant', () {
    expect(resolveRemoteUserIdForConversation('u1:u2', 'u1'), 'u2');
    expect(resolveRemoteUserIdForConversation('u1:u2', 'u2'), 'u1');
  });

  test(
    'resolveRemoteUserIdForConversation rejects invalid conversation ids',
    () {
      expect(
        () => resolveRemoteUserIdForConversation('', 'u1'),
        throwsArgumentError,
      );
      expect(
        () => resolveRemoteUserIdForConversation('u1', 'u1'),
        throwsArgumentError,
      );
      expect(
        () => resolveRemoteUserIdForConversation('u1:u2:u3', 'u1'),
        throwsArgumentError,
      );
      expect(
        () => resolveRemoteUserIdForConversation('u1:u1', 'u1'),
        throwsArgumentError,
      );
      expect(
        () => resolveRemoteUserIdForConversation('u2:u3', 'u1'),
        throwsArgumentError,
      );
    },
  );

  test(
    'ensureConversationForContact prefers the exact A-B direct conversation over unrelated A-C records',
    () async {
      final logger = AppLogger();
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      final repo = ChatsRepositoryImpl(
        ChatsApiClient(
          ApiClient(dio: Dio(), storage: SecureStorageService(
            const FlutterSecureStorage(),
            logger,
          ), logger: logger),
        ),
        db,
        logger,
        'user-a',
        DeviceInfoService(logger),
        ThrowingCryptoService(
          SecureStorageService(const FlutterSecureStorage(), logger),
          logger,
          ApiClient(dio: Dio(), storage: SecureStorageService(
            const FlutterSecureStorage(),
            logger,
          ), logger: logger),
          DeviceInfoService(logger),
          DriftSignalProtocolStore(db),
        ),
      );

      await db.chatsDao.upsertConversations([
        ConversationsCompanion(
          id: const Value('conv-ab'),
          type: const Value('direct'),
          title: const Value('B'),
          lastSequence: Value(BigInt.zero),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
          deletedAt: const Value.absent(),
        ),
        ConversationsCompanion(
          id: const Value('conv-ac'),
          type: const Value('direct'),
          title: const Value('C'),
          lastSequence: Value(BigInt.zero),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
          deletedAt: const Value.absent(),
        ),
      ]);

      await db.chatsDao.upsertMembers([
        ConversationMembersCompanion(
          id: const Value('conv-ab:user-a'),
          conversationId: const Value('conv-ab'),
          userId: const Value('user-a'),
          role: const Value('admin'),
          lastReadSequence: Value(BigInt.zero),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
          deletedAt: const Value.absent(),
        ),
        ConversationMembersCompanion(
          id: const Value('conv-ab:user-b'),
          conversationId: const Value('conv-ab'),
          userId: const Value('user-b'),
          role: const Value('member'),
          lastReadSequence: Value(BigInt.zero),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
          deletedAt: const Value.absent(),
        ),
        ConversationMembersCompanion(
          id: const Value('conv-ac:user-a'),
          conversationId: const Value('conv-ac'),
          userId: const Value('user-a'),
          role: const Value('admin'),
          lastReadSequence: Value(BigInt.zero),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
          deletedAt: const Value.absent(),
        ),
        ConversationMembersCompanion(
          id: const Value('conv-ac:user-c'),
          conversationId: const Value('conv-ac'),
          userId: const Value('user-c'),
          role: const Value('member'),
          lastReadSequence: Value(BigInt.zero),
          createdAt: Value(DateTime.now()),
          updatedAt: Value(DateTime.now()),
          deletedAt: const Value.absent(),
        ),
      ]);

      final result = await repo.ensureConversationForContact('user-b');
      expect(result, 'conv-ab');
    },
  );

  test(
    'ensureConversationForContact rejects ambiguous duplicate direct conversations for the same peer',
    () async {
      final logger = AppLogger();
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      final repo = ChatsRepositoryImpl(
        ChatsApiClient(
          ApiClient(dio: Dio(), storage: SecureStorageService(
            const FlutterSecureStorage(),
            logger,
          ), logger: logger),
        ),
        db,
        logger,
        'user-a',
        DeviceInfoService(logger),
        ThrowingCryptoService(
          SecureStorageService(const FlutterSecureStorage(), logger),
          logger,
          ApiClient(dio: Dio(), storage: SecureStorageService(
            const FlutterSecureStorage(),
            logger,
          ), logger: logger),
          DeviceInfoService(logger),
          DriftSignalProtocolStore(db),
        ),
      );

      final now = DateTime.now();
      await db.chatsDao.upsertConversations([
        ConversationsCompanion(
          id: const Value('conv-ab-1'),
          type: const Value('direct'),
          title: const Value('B'),
          lastSequence: Value(BigInt.zero),
          createdAt: Value(now),
          updatedAt: Value(now),
          deletedAt: const Value.absent(),
        ),
        ConversationsCompanion(
          id: const Value('conv-ab-2'),
          type: const Value('direct'),
          title: const Value('B2'),
          lastSequence: Value(BigInt.zero),
          createdAt: Value(now),
          updatedAt: Value(now),
          deletedAt: const Value.absent(),
        ),
      ]);

      await db.chatsDao.upsertMembers([
        ConversationMembersCompanion(
          id: const Value('conv-ab-1:user-a'),
          conversationId: const Value('conv-ab-1'),
          userId: const Value('user-a'),
          role: const Value('admin'),
          lastReadSequence: Value(BigInt.zero),
          createdAt: Value(now),
          updatedAt: Value(now),
          deletedAt: const Value.absent(),
        ),
        ConversationMembersCompanion(
          id: const Value('conv-ab-1:user-b'),
          conversationId: const Value('conv-ab-1'),
          userId: const Value('user-b'),
          role: const Value('member'),
          lastReadSequence: Value(BigInt.zero),
          createdAt: Value(now),
          updatedAt: Value(now),
          deletedAt: const Value.absent(),
        ),
        ConversationMembersCompanion(
          id: const Value('conv-ab-2:user-a'),
          conversationId: const Value('conv-ab-2'),
          userId: const Value('user-a'),
          role: const Value('admin'),
          lastReadSequence: Value(BigInt.zero),
          createdAt: Value(now),
          updatedAt: Value(now),
          deletedAt: const Value.absent(),
        ),
        ConversationMembersCompanion(
          id: const Value('conv-ab-2:user-b'),
          conversationId: const Value('conv-ab-2'),
          userId: const Value('user-b'),
          role: const Value('member'),
          lastReadSequence: Value(BigInt.zero),
          createdAt: Value(now),
          updatedAt: Value(now),
          deletedAt: const Value.absent(),
        ),
      ]);

      expect(
        () => repo.ensureConversationForContact('user-b'),
        throwsStateError,
      );
    },
  );

  test(
    'resolvePeerUserIdForConversation rejects non-direct multi-participant conversations',
    () async {
      final logger = AppLogger();
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      final repo = ChatsRepositoryImpl(
        ChatsApiClient(
          ApiClient(dio: Dio(), storage: SecureStorageService(
            const FlutterSecureStorage(),
            logger,
          ), logger: logger),
        ),
        db,
        logger,
        'user-a',
        DeviceInfoService(logger),
        ThrowingCryptoService(
          SecureStorageService(const FlutterSecureStorage(), logger),
          logger,
          ApiClient(dio: Dio(), storage: SecureStorageService(
            const FlutterSecureStorage(),
            logger,
          ), logger: logger),
          DeviceInfoService(logger),
          DriftSignalProtocolStore(db),
        ),
      );

      final now = DateTime.now();
      await db.chatsDao.upsertConversations([
        ConversationsCompanion(
          id: const Value('group-1'),
          type: const Value('group'),
          title: const Value('Grupa'),
          lastSequence: Value(BigInt.zero),
          createdAt: Value(now),
          updatedAt: Value(now),
          deletedAt: const Value.absent(),
        ),
      ]);

      await db.chatsDao.upsertMembers([
        ConversationMembersCompanion(
          id: const Value('group-1:user-a'),
          conversationId: const Value('group-1'),
          userId: const Value('user-a'),
          role: const Value('admin'),
          lastReadSequence: Value(BigInt.zero),
          createdAt: Value(now),
          updatedAt: Value(now),
          deletedAt: const Value.absent(),
        ),
        ConversationMembersCompanion(
          id: const Value('group-1:user-b'),
          conversationId: const Value('group-1'),
          userId: const Value('user-b'),
          role: const Value('member'),
          lastReadSequence: Value(BigInt.zero),
          createdAt: Value(now),
          updatedAt: Value(now),
          deletedAt: const Value.absent(),
        ),
        ConversationMembersCompanion(
          id: const Value('group-1:user-c'),
          conversationId: const Value('group-1'),
          userId: const Value('user-c'),
          role: const Value('member'),
          lastReadSequence: Value(BigInt.zero),
          createdAt: Value(now),
          updatedAt: Value(now),
          deletedAt: const Value.absent(),
        ),
      ]);

      expect(
        () => repo.resolvePeerUserIdForConversation('group-1'),
        throwsArgumentError,
      );
    },
  );

  test(
    'registerDeviceIdentity is idempotent and posts only public key material',
    () async {
      final logger = AppLogger();
      final secureStorage = SecureStorageService(
        const FlutterSecureStorage(),
        logger,
      );
      final apiClient = RecordingApiClient(
        storage: secureStorage,
        logger: logger,
      );
      final deviceInfoService = DeviceInfoService(logger);
      final db = AppDatabase(NativeDatabase.memory());
      final cryptoService = E2eeCryptoService(
        secureStorage,
        logger,
        apiClient,
        deviceInfoService,
        DriftSignalProtocolStore(db),
      );

      await cryptoService.registerDeviceIdentity();
      await cryptoService.registerDeviceIdentity();

      expect(apiClient.requests, ['/crypto/keys/device']);
      final payload = apiClient.payloads.single;
      expect(payload.containsKey('identity_public_key'), isTrue);
      expect(payload.containsKey('public_key'), isTrue);
      expect(payload.containsKey('private_key'), isFalse);
      expect(payload.containsKey('device_private_key'), isFalse);
      expect(payload['identity_public_key'], isNotNull);
      expect(payload['public_key'], isNotNull);
    },
  );

  test(
    'sendMessage encrypts for remote user id, not conversation id',
    () async {
      final logger = AppLogger();
      final db = AppDatabase(NativeDatabase.memory());
      final secureStorage = SecureStorageService(
        const FlutterSecureStorage(),
        logger,
      );
      final deviceInfoService = DeviceInfoService(logger);
      final signalStore = DriftSignalProtocolStore(db);
      final cryptoService = CapturingCryptoService(
        secureStorage,
        logger,
        ApiClient(dio: Dio(), storage: secureStorage, logger: logger),
        deviceInfoService,
        signalStore,
      );
      final repository = ChatsRepositoryImpl(
        ChatsApiClient(
          ApiClient(dio: Dio(), storage: secureStorage, logger: logger),
        ),
        db,
        logger,
        'u1',
        deviceInfoService,
        cryptoService,
      );

      await repository.sendMessage(conversationId: 'u1:u2', content: 'secret');

      expect(cryptoService.lastPeerUserId, 'u2');
      expect(cryptoService.lastPlaintext, 'secret');
    },
  );

  test(
    'sendMessage aborts without storing plaintext when encryption fails',
    () async {
      final logger = AppLogger();
      final db = AppDatabase(NativeDatabase.memory());
      final secureStorage = SecureStorageService(
        const FlutterSecureStorage(),
        logger,
      );
      final deviceInfoService = DeviceInfoService(logger);
      final cryptoService = FailingCryptoService(
        secureStorage,
        logger,
        ApiClient(dio: Dio(), storage: secureStorage, logger: logger),
        deviceInfoService,
        DriftSignalProtocolStore(db),
      );
      final repository = ChatsRepositoryImpl(
        ChatsApiClient(
          ApiClient(dio: Dio(), storage: secureStorage, logger: logger),
        ),
        db,
        logger,
        'u1',
        deviceInfoService,
        cryptoService,
      );

      expect(
        () =>
            repository.sendMessage(conversationId: 'u1:u2', content: 'secret'),
        throwsStateError,
      );

      final storedMessages = await db.select(db.messages).get();
      expect(storedMessages, isEmpty);
    },
  );
}
