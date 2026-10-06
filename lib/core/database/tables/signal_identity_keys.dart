import 'package:drift/drift.dart';

class SignalIdentityKeys extends Table {
  TextColumn get name => text()();

  IntColumn get deviceId => integer()();

  BlobColumn get identityKey => blob()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {name, deviceId};
}
