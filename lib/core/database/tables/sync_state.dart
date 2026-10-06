import 'package:drift/drift.dart';

@DataClassName('SyncStateEntity')
class SyncState extends Table {
  TextColumn get userId => text()();

  Int64Column get lastKnownMessageVersion => int64()();

  Int64Column get lastKnownContactVersion => int64()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {userId};
}
