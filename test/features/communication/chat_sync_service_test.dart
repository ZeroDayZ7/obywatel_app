import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/clients/app_websocket_client.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/communication/application/chat_sync_service.dart';
import 'package:obywatel_plus/features/communication/application/outbox/outbox_processor.dart';
import 'package:obywatel_plus/features/communication/application/outbox/outbox_transport_client.dart';
import 'package:obywatel_plus/features/communication/application/sync_status.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_api_client.dart';
import 'package:obywatel_plus/features/communication/data/datasources/chats_ws_client.dart';
import 'package:obywatel_plus/features/communication/data/dtos/conversation_dto.dart';
import 'package:obywatel_plus/features/communication/domain/chats/conversation.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:obywatel_plus/features/communication/domain/outbox/outbox_event.dart';
import 'package:obywatel_plus/features/communication/domain/repositories/chats_repository.dart';

class _TestTransportClient implements OutboxTransportClient {
  @override
  Future<void> sendOutboxBatch(List<Map<String, dynamic>> payload) async {}
}

class _TestChatsApiClient extends ChatsApiClient {
  _TestChatsApiClient()
    : super(
        ApiClient(
          dio: Dio(),
          storage: SecureStorageService(
            const FlutterSecureStorage(),
            AppLogger(),
          ),
          logger: AppLogger(),
        ),
      );

  int getConversationsCalls = 0;

  @override
  Future<List<ConversationDto>> getConversations() async {
    getConversationsCalls += 1;
    return const <ConversationDto>[];
  }
}

class _TrackingWsClient extends ChatsWsClient {
  _TrackingWsClient()
    : _statusController = StreamController<WsConnectionStatus>.broadcast(),
      super(
        AppWebSocketClient(logger: AppLogger()),
        AppLogger(),
        DeviceInfoService(AppLogger()),
      );

  final StreamController<WsConnectionStatus> _statusController;
  int listenCount = 0;

  @override
  Stream<WsConnectionStatus> get statusStream => Stream.multi((controller) {
    listenCount += 1;
    final subscription = _statusController.stream.listen(
      controller.add,
      onError: controller.addError,
      onDone: controller.close,
    );
    controller.onCancel = subscription.cancel;
  });

  void emit(WsConnectionStatus status) => _statusController.add(status);
}

class _TestRepository implements ChatsRepository {
  _TestRepository({this.blockDelta = false});

  final bool blockDelta;
  int syncDeltaCalls = 0;
  int forceSyncRuns = 0;
  Completer<void>? _deltaGate;

  void releaseDelta() {
    if (_deltaGate != null && !_deltaGate!.isCompleted) {
      _deltaGate!.complete();
    }
  }

  @override
  Future<List<Map<String, dynamic>>> syncDeltaFromRemote({
    int lastKnownContactVersion = 0,
    int lastKnownMessageVersion = 0,
  }) async {
    syncDeltaCalls += 1;
    if (blockDelta) {
      _deltaGate ??= Completer<void>();
      await _deltaGate!.future;
    }
    return const <Map<String, dynamic>>[];
  }

  @override
  Stream<List<Conversation>> watchConversations() => const Stream.empty();

  @override
  Stream<List<Message>> watchMessagesForConversation(String conversationId) =>
      const Stream.empty();

  @override
  Future<List<Conversation>> getConversations() async => const <Conversation>[];

  @override
  Future<String> resolvePeerUserIdForConversation(String conversationId) async =>
      '';

  @override
  Future<String> ensureSelfConversation() async => '';

  @override
  Future<String> ensureConversationForContact(
    String contactUserId, {
    String? title,
  }) async => '';

  @override
  Future<void> ensureE2eeSessionForContact(String contactUserId) async {}

  @override
  Future<List<Message>> getMessageHistory(
    String conversationId, {
    String? beforeId,
    int limit = 50,
  }) async => const <Message>[];

  @override
  Future<void> sendMessage({
    required String conversationId,
    required String content,
    String? attachmentId,
  }) async {}

  @override
  Future<Map<String, dynamic>?> getAttachmentMetadata(String attachmentId) async =>
      null;

  @override
  Future<String?> getAttachmentKey(String attachmentId) async => null;

  @override
  Future<void> saveAttachmentKey({
    required String attachmentId,
    required String attachmentKey,
  }) async {}

  @override
  Future<void> deleteAttachmentKey(String attachmentId) async {}

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
  }) async {}

  @override
  Stream<Message> get incomingMessagesStream => const Stream.empty();

  @override
  Future<List<Message>> getPendingOutboxMessages() async => const <Message>[];

  @override
  Future<List<OutboxEvent>> getRetryEligibleOutboxEvents({
    DateTime? referenceTime,
  }) async => const <OutboxEvent>[];

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
  Future<void> clearSentOutboxMessages(List<String> messageIds) async {}

  @override
  Future<List<Conversation>> saveConversationsFromRemote(
    List<ConversationDto> dtos,
  ) async => const <Conversation>[];
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const secureStorageChannel = MethodChannel(
    'plugins.it_nomads.com/flutter_secure_storage',
  );
  final secureStorageStore = <String, String>{};

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(secureStorageChannel, (MethodCall call) async {
        switch (call.method) {
          case 'read':
            return secureStorageStore[call.arguments['key'] as String];
          case 'write':
            final key = call.arguments['key'] as String?;
            final value = call.arguments['value'] as String?;
            if (key != null && value != null) {
              secureStorageStore[key] = value;
            }
            return null;
          case 'delete':
            final key = call.arguments['key'] as String?;
            if (key != null) {
              secureStorageStore.remove(key);
            }
            return null;
          case 'readAll':
            return secureStorageStore;
          case 'deleteAll':
            secureStorageStore.clear();
            return null;
          default:
            return null;
        }
      });

  test('init() registers only one WS subscription even if called multiple times', () {
    final wsClient = _TrackingWsClient();
    final repo = _TestRepository();
    final apiClient = _TestChatsApiClient();
    final service = ChatSyncService(
      apiClient,
      wsClient,
      repo,
      AppLogger(),
      (_) {},
      outboxProcessor: OutboxProcessor(
        repo,
        _TestTransportClient(),
        AppLogger(),
        DeviceInfoService(AppLogger()),
      ),
    );

    service.init();
    service.init();

    expect(wsClient.listenCount, 1);
  });

  test('dispose blocks any later sync attempt and cancels WS listener', () async {
    final wsClient = _TrackingWsClient();
    final repo = _TestRepository();
    final apiClient = _TestChatsApiClient();
    final service = ChatSyncService(
      apiClient,
      wsClient,
      repo,
      AppLogger(),
      (_) {},
      outboxProcessor: OutboxProcessor(
        repo,
        _TestTransportClient(),
        AppLogger(),
        DeviceInfoService(AppLogger()),
      ),
    );

    service.startSession();
    service.dispose();
    await service.syncPendingData();

    expect(repo.syncDeltaCalls, 0);
    expect(wsClient.listenCount, 1);
  });

  test('multiple connected events do not overlap and sync executes once', () async {
    final wsClient = _TrackingWsClient();
    final repo = _TestRepository();
    final apiClient = _TestChatsApiClient();
    final service = ChatSyncService(
      apiClient,
      wsClient,
      repo,
      AppLogger(),
      (_) {},
      outboxProcessor: OutboxProcessor(
        repo,
        _TestTransportClient(),
        AppLogger(),
        DeviceInfoService(AppLogger()),
      ),
    );

    service.startSession();
    wsClient.emit(WsConnectionStatus.connected);
    wsClient.emit(WsConnectionStatus.connected);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(repo.syncDeltaCalls, 1);
  });

  test('stopSession during an in-flight sync prevents stale state updates', () async {
    final wsClient = _TrackingWsClient();
    final repo = _TestRepository(blockDelta: true);
    final apiClient = _TestChatsApiClient();
    final statuses = <SyncStatus>[];
    final service = ChatSyncService(
      apiClient,
      wsClient,
      repo,
      AppLogger(),
      statuses.add,
      outboxProcessor: OutboxProcessor(
        repo,
        _TestTransportClient(),
        AppLogger(),
        DeviceInfoService(AppLogger()),
      ),
    );

    service.startSession();
    final syncFuture = service.syncPendingData();
    service.stopSession();
    repo.releaseDelta();
    await syncFuture;

    expect(statuses, contains(SyncStatus.idle));
    expect(statuses, isNot(contains(SyncStatus.error)));
    expect(repo.syncDeltaCalls, 0);
  });

  test('service restarts correctly after logout and subsequent login', () async {
    final wsClient = _TrackingWsClient();
    final repo = _TestRepository();
    final apiClient = _TestChatsApiClient();
    final service = ChatSyncService(
      apiClient,
      wsClient,
      repo,
      AppLogger(),
      (_) {},
      outboxProcessor: OutboxProcessor(
        repo,
        _TestTransportClient(),
        AppLogger(),
        DeviceInfoService(AppLogger()),
      ),
    );

    service.startSession();
    service.stopSession();
    service.startSession();
    wsClient.emit(WsConnectionStatus.connected);
    await Future<void>.delayed(const Duration(milliseconds: 20));

    expect(repo.syncDeltaCalls, 1);
    expect(service.currentStatus, SyncStatus.idle);
  });
}
