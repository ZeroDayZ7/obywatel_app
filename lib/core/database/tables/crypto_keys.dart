import 'package:drift/drift.dart';

class CryptoKeys extends Table {
  TextColumn get id => text()();

  BlobColumn get privateKey => blob()();
  BlobColumn get publicKey => blob()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
