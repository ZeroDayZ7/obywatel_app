import 'package:drift/drift.dart';

class SignalSignedPreKeys extends Table {
  IntColumn get id => integer()();

  BlobColumn get record => blob()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
