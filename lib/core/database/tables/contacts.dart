import 'package:drift/drift.dart';

@DataClassName('ContactEntity')
class Contacts extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  TextColumn get contactId => text()();

  // Status: 'pending', 'accepted', 'blocked'
  TextColumn get status => text().withDefault(const Constant('pending'))();

  // Szyfrowany alias nadany lokalnie przez użytkownika
  BlobColumn get encryptedAlias => blob().nullable()();

  // Wersjonowanie dla silnika Delta Sync
  Int64Column get version => int64().withDefault(Constant(BigInt.from(1)))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
