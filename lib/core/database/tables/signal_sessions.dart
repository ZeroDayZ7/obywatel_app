import 'package:drift/drift.dart';

class SignalSessions extends Table {
  TextColumn get name => text()();

  IntColumn get deviceId => integer()();

  BlobColumn get record => blob()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {name, deviceId};
}
