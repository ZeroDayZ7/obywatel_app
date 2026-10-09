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

AppDatabase _buildDb() => AppDatabase(NativeDatabase.memory());

Future<ContactsRepositoryImpl> _buildRepo(
  AppDatabase db, {
  required String currentUserId,
  List<ContactDto> contacts = const [],
}) async {
  return ContactsRepositoryImpl(
    _FakeContactsApiClient(contacts),
    db.contactsDao,
    db.outboxDao,
    currentUserId,
  );
}

void main() {
  test('A sends invite to B and B sees exactly one incoming pending row', () async {
    final db = _buildDb();
    addTearDown(db.close);

    final repo = await _buildRepo(db, currentUserId: 'user-b', contacts: [
      ContactDto(
        id: 'server-1',
        ownerId: 'user-a',
        contactId: 'user-b',
        status: 'pending',
        direction: 'outgoing',
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ]);

    await repo.fetchAndSyncContacts();

    final rows = await db.select(db.contacts).get();
    expect(rows, hasLength(1));
    expect(rows.single.ownerId, 'user-a');
    expect(rows.single.contactId, 'user-b');
    expect(rows.single.status, 'pending');
    expect(rows.single.direction, 'outgoing');
  });

  test('Repeated fetch is idempotent and does not create duplicate outgoing rows', () async {
    final db = _buildDb();
    addTearDown(db.close);

    final dto = ContactDto(
      id: 'server-1',
      ownerId: 'user-a',
      contactId: 'user-b',
      status: 'pending',
      direction: 'outgoing',
      version: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final repo = await _buildRepo(db, currentUserId: 'user-a', contacts: [dto]);

    await repo.fetchAndSyncContacts();
    await repo.fetchAndSyncContacts();

    final rows = await db.select(db.contacts).get();
    expect(rows, hasLength(1));
    expect(rows.single.id, 'server-1');
  });

  test('Local placeholder merges with server record without duplicate', () async {
    final db = _buildDb();
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
        localAlias: const Value('Alias lokalny'),
        encryptedAlias: const Value.absent(),
        version: Value(BigInt.one),
        createdAt: Value(now),
        updatedAt: Value(now),
        deletedAt: const Value.absent(),
      ),
    );

    final repo = await _buildRepo(db, currentUserId: 'user-a', contacts: [
      ContactDto(
        id: 'server-1',
        ownerId: 'user-a',
        contactId: 'user-b',
        status: 'pending',
        direction: 'outgoing',
        version: 1,
        createdAt: now,
        updatedAt: now,
      ),
    ]);

    await repo.fetchAndSyncContacts();

    final rows = await db.select(db.contacts).get();
    expect(rows, hasLength(1));
    expect(rows.single.id, 'server-1');
    expect(rows.single.ownerId, 'user-a');
    expect(rows.single.contactId, 'user-b');
    expect(rows.single.localAlias, 'Alias lokalny');
  });

  test('Two independent senders to the same recipient stay visible as two rows', () async {
    final db = _buildDb();
    addTearDown(db.close);

    final repo = await _buildRepo(db, currentUserId: 'user-b', contacts: [
      ContactDto(
        id: 'server-a',
        ownerId: 'user-a',
        contactId: 'user-b',
        status: 'pending',
        direction: 'outgoing',
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ContactDto(
        id: 'server-c',
        ownerId: 'user-c',
        contactId: 'user-b',
        status: 'pending',
        direction: 'outgoing',
        version: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ]);

    await repo.fetchAndSyncContacts();

    final rows = await db.select(db.contacts).get();
    expect(rows, hasLength(2));
    expect(
      rows.map((r) => '${r.ownerId}:${r.contactId}').toSet(),
      {'user-a:user-b', 'user-c:user-b'},
    );
  });

  test('Accepting a request does not duplicate the relation', () async {
    final db = _buildDb();
    addTearDown(db.close);

    final dto = ContactDto(
      id: 'server-1',
      ownerId: 'user-a',
      contactId: 'user-b',
      status: 'accepted',
      direction: 'outgoing',
      version: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final repo = await _buildRepo(db, currentUserId: 'user-b', contacts: [dto]);
    await repo.fetchAndSyncContacts();
    await repo.fetchAndSyncContacts();

    final rows = await db.select(db.contacts).get();
    expect(rows, hasLength(1));
    expect(rows.single.status, 'accepted');
    expect(rows.single.direction, 'outgoing');
  });
}
