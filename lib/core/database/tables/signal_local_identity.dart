import 'package:drift/drift.dart';

class SignalLocalIdentity extends Table {
  TextColumn get id => text()();

  BlobColumn get identityKeyPair => blob()();

  IntColumn get registrationId => integer()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
