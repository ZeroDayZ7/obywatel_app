import 'package:drift/drift.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/tables/contacts.dart';

part 'contacts_dao.g.dart';

@DriftAccessor(tables: [Contacts])
class ContactsDao extends DatabaseAccessor<AppDatabase>
    with _$ContactsDaoMixin {
  ContactsDao(super.db);

  Stream<List<ContactEntity>> watchAcceptedContacts() {
    return (select(contacts)
          ..where((t) => t.status.equals('accepted') & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  Stream<List<ContactEntity>> watchPendingContacts() {
    return (select(contacts)
          ..where((t) => t.status.equals('pending') & t.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<ContactEntity?> getContactByContactId(String contactId) {
    return (select(contacts)
          ..where((t) => t.contactId.equals(contactId) & t.deletedAt.isNull()))
        .getSingleOrNull();
  }

  Future<BigInt> getMaxContactVersion() async {
    final maxVerExpr = contacts.version.max();
    final query = selectOnly(contacts)..addColumns([maxVerExpr]);

    final result = await query
        .map((row) => row.read(maxVerExpr))
        .getSingleOrNull();
    return result ?? BigInt.zero;
  }

  Future<void> upsertContacts(List<ContactsCompanion> items) async {
    await batch((batch) {
      batch.insertAll(contacts, items, mode: InsertMode.insertOrReplace);
    });
  }

  Future<void> updateStatus({
    required String id,
    required String status,
  }) async {
    await (update(contacts)..where((t) => t.id.equals(id))).write(
      ContactsCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
