import 'package:dio/dio.dart';
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
    String plaintext,
  ) async {
    lastPeerUserId = remoteUserId;
    lastPlaintext = plaintext;

    return const EncryptedData(
      ciphertextBase64: 'ciphertext-from-peer',
      nonceBase64: 'nonce',
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
    String plaintext,
  ) async {
    throw StateError('Encryption failed before any plaintext could be sent');
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

  test('ensureConversationForContact does not bootstrap E2EE session', () async {
    final logger = AppLogger();
    final db = AppDatabase(NativeDatabase.memory());
    final secureStorage = SecureStorageService(const FlutterSecureStorage(), logger);
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
        ApiClient(
          dio: Dio(),
          storage: secureStorage,
          logger: logger,
        ),
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
  });

  test('resolveRemoteUserIdForConversation returns the other participant', () {
    expect(resolveRemoteUserIdForConversation('u1:u2', 'u1'), 'u2');
    expect(resolveRemoteUserIdForConversation('u1:u2', 'u2'), 'u1');
  });

  test('resolveRemoteUserIdForConversation rejects invalid conversation ids', () {
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
  });

  test('sendMessage encrypts for remote user id, not conversation id', () async {
    final logger = AppLogger();
    final db = AppDatabase(NativeDatabase.memory());
    final secureStorage = SecureStorageService(const FlutterSecureStorage(), logger);
    final deviceInfoService = DeviceInfoService(logger);
    final signalStore = DriftSignalProtocolStore(db);
    final cryptoService = CapturingCryptoService(
      secureStorage,
      logger,
      ApiClient(
        dio: Dio(),
        storage: secureStorage,
        logger: logger,
      ),
      deviceInfoService,
      signalStore,
    );
    final repository = ChatsRepositoryImpl(
      ChatsApiClient(
        ApiClient(
          dio: Dio(),
          storage: secureStorage,
          logger: logger,
        ),
      ),
      db,
      logger,
      'u1',
      deviceInfoService,
      cryptoService,
    );

    await repository.sendMessage(
      conversationId: 'u1:u2',
      content: 'secret',
    );

    expect(cryptoService.lastPeerUserId, 'u2');
    expect(cryptoService.lastPlaintext, 'secret');
  });

  test('sendMessage aborts without storing plaintext when encryption fails', () async {
    final logger = AppLogger();
    final db = AppDatabase(NativeDatabase.memory());
    final secureStorage = SecureStorageService(const FlutterSecureStorage(), logger);
    final deviceInfoService = DeviceInfoService(logger);
    final cryptoService = FailingCryptoService(
      secureStorage,
      logger,
      ApiClient(
        dio: Dio(),
        storage: secureStorage,
        logger: logger,
      ),
      deviceInfoService,
      DriftSignalProtocolStore(db),
    );
    final repository = ChatsRepositoryImpl(
      ChatsApiClient(
        ApiClient(
          dio: Dio(),
          storage: secureStorage,
          logger: logger,
        ),
      ),
      db,
      logger,
      'u1',
      deviceInfoService,
      cryptoService,
    );

    expect(
      () => repository.sendMessage(
        conversationId: 'u1:u2',
        content: 'secret',
      ),
      throwsStateError,
    );

    final storedMessages = await db.select(db.messages).get();
    expect(storedMessages, isEmpty);
  });
}
