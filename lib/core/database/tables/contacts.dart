// lib/core/database/tables/contacts.dart
import 'package:drift/drift.dart';

@DataClassName('ContactEntity')
class Contacts extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  TextColumn get contactId => text()();

  // Status: 'pending', 'accepted', 'blocked'
  TextColumn get status => text().withDefault(const Constant('pending'))();

  // Faza Offline-First: synchronizowane lokalnie, nie nadpisywane przez serwer.
  TextColumn get syncState => text().withDefault(const Constant('synced'))();
  TextColumn get direction => text().withDefault(const Constant('incoming'))();

  // Globalny kursor zmian kontaktu w ramach użytkownika.
  Int64Column get changeSequence => int64().withDefault(Constant(BigInt.from(1)))();

  // Główna, lokalna nazwa użytkownika nadana przez osobę dodającą.
  TextColumn get localAlias => text().nullable()();

  // Legacy: pozostawione dla kompatybilności migracyjnej.
  BlobColumn get encryptedAlias => blob().nullable()();

  // Wersjonowanie dla silnika Delta Sync
  Int64Column get version => int64().withDefault(Constant(BigInt.from(1)))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
