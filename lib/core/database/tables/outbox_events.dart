import 'package:drift/drift.dart';

@DataClassName('OutboxEventEntity')
class OutboxEvents extends Table {
  TextColumn get id => text()();

  // Typ akcji, np. "SEND_MESSAGE", "ADD_CONTACT", "READ_ACK"
  TextColumn get eventType => text()();

  TextColumn get conversationId => text().nullable()();

  // Ścieżka JSON zawierająca dokładny payload zdarzenia
  TextColumn get payload => text()();

  // Status przetworzenia w kolejce lokalnej: 'pending', 'sending', 'failed'
  TextColumn get status => text().withDefault(const Constant('pending'))();

  // Licznik nieudanych prób synchronizacji
  IntColumn get retryCount => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
