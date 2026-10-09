import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/features/communication/data/datasources/contacts_api_client.dart';
import 'package:obywatel_plus/features/communication/data/dtos/contact_dto.dart';
import 'package:obywatel_plus/features/communication/data/repositories/contacts_repository_impl.dart';

class _FakeApiClient extends ApiClient {
  _FakeApiClient()
      : super(
          dio: Dio(),
          storage: SecureStorageService(
            const FlutterSecureStorage(),
            AppLogger(),
          ),
          logger: AppLogger(),
        );
}

class FakeContactsApiClient extends ContactsApiClient {
  FakeContactsApiClient() : super(_FakeApiClient());

  bool sendRequestCalled = false;
  String? sentTargetUserId;
  bool respondCalled = false;
  String? respondedRequestId;
  bool? respondedAccept;
  List<ContactDto> contactDtos = const [];

  @override
  Future<List<ContactDto>> getContacts() async => contactDtos;

  @override
  Future<void> sendContactRequest(String targetUserId) async {
    sendRequestCalled = true;
    sentTargetUserId = targetUserId;
  }

  @override
  Future<void> respondToRequest(String requestId, bool accept) async {
    respondCalled = true;
    respondedRequestId = requestId;
    respondedAccept = accept;
  }
}

void main() {
  group('ContactsRepositoryImpl', () {
    test('sendRequest calls backend endpoint before local pending write', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      final apiClient = FakeContactsApiClient();
      final repo = ContactsRepositoryImpl(apiClient, db.contactsDao, db.outboxDao);

      const targetUserId = '123e4567-e89b-12d3-a456-426614174000';

      await repo.sendRequest(targetUserId);

      expect(apiClient.sendRequestCalled, isTrue);
      expect(apiClient.sentTargetUserId, targetUserId);
    });

    test('respondToRequest calls backend endpoint before local status change', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      final apiClient = FakeContactsApiClient();
      final repo = ContactsRepositoryImpl(apiClient, db.contactsDao, db.outboxDao);

      const requestId = '123e4567-e89b-12d3-a456-426614174001';

      await repo.respondToRequest(requestId, true);

      expect(apiClient.respondCalled, isTrue);
      expect(apiClient.respondedRequestId, requestId);
      expect(apiClient.respondedAccept, isTrue);
    });

    test('fetchAndSyncContacts removes stale pending duplicate after accepted response', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      final apiClient = FakeContactsApiClient();
      apiClient.contactDtos = [
        ContactDto(
          id: 'accepted-row-id',
          ownerId: 'owner-1',
          contactId: 'user-2',
          status: 'accepted',
          direction: 'incoming',
          version: 2,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      final stalePending = ContactsCompanion(
        id: const Value('pending-row-id'),
        ownerId: const Value('owner-1'),
        contactId: const Value('user-2'),
        status: const Value('pending'),
        syncState: const Value('synced'),
        direction: const Value('incoming'),
        changeSequence: Value(BigInt.one),
        localAlias: const Value.absent(),
        encryptedAlias: const Value.absent(),
        version: Value(BigInt.one),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
        deletedAt: const Value.absent(),
      );

      await db.contactsDao.upsertContacts([stalePending]);

      final repo = ContactsRepositoryImpl(apiClient, db.contactsDao, db.outboxDao);
      await repo.fetchAndSyncContacts();

      final pendingRows = await (db.select(db.contacts)
            ..where((t) => t.contactId.equals('user-2') & t.status.equals('pending') & t.deletedAt.isNull()))
          .get();

      expect(pendingRows, isEmpty);
    });
  });
}
