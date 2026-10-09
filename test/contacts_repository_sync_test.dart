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

class _FakeContactsApiClient extends ContactsApiClient {
  _FakeContactsApiClient(this._contacts)
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

  final List<ContactDto> _contacts;

  @override
  Future<List<ContactDto>> getContacts() async => _contacts;
}

void main() {
  test(
    'fetchAndSyncContacts removes local placeholder duplicates while keeping the server record',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      final now = DateTime.now();
      await db.into(db.contacts).insert(
        ContactsCompanion(
          id: const Value('local-placeholder'),
          ownerId: const Value('local_user'),
          contactId: const Value('user-b'),
          status: const Value('pending'),
          syncState: const Value('pending_create'),
          direction: const Value('outgoing'),
          changeSequence: Value(BigInt.one),
          localAlias: const Value.absent(),
          encryptedAlias: const Value.absent(),
          version: Value(BigInt.one),
          createdAt: Value(now),
          updatedAt: Value(now),
          deletedAt: const Value.absent(),
        ),
      );

      final dto = ContactDto(
        id: 'server-1',
        ownerId: 'user-a',
        contactId: 'user-b',
        status: 'pending',
        direction: 'outgoing',
        version: 1,
        createdAt: now,
        updatedAt: now,
      );

      final repo = ContactsRepositoryImpl(
        _FakeContactsApiClient([dto]),
        db.contactsDao,
        db.outboxDao,
        'user-a',
      );

      await repo.fetchAndSyncContacts();

      final rows = await db.select(db.contacts).get();
      final matching = rows.where((row) => row.contactId == 'user-b').toList();

      expect(matching, hasLength(1));
      expect(matching.single.ownerId, 'user-a');
      expect(matching.single.id, 'server-1');
    },
  );
}
