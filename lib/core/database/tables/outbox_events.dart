import 'package:drift/drift.dart';

@DataClassName('OutboxEventEntity')
class OutboxEvents extends Table {
  TextColumn get id => text()();

  // Typ jednostki zmienianej w outboxie: CONTACT, CONVERSATION, MESSAGE
  TextColumn get entityType => text().withDefault(const Constant('GENERIC'))();
  TextColumn get entityId => text().nullable()();

  // Typ akcji, np. "SEND_MESSAGE", "ADD_CONTACT", "READ_ACK"
  TextColumn get eventType => text()();

  TextColumn get conversationId => text().nullable()();

  // Ścieżka JSON zawierająca dokładny payload zdarzenia
  TextColumn get payload => text()();

  // Status przetworzenia w kolejce lokalnej: 'pending', 'sending', 'failed'
  TextColumn get status => text().withDefault(const Constant('pending'))();

  // Licznik nieudanych prób synchronizacji
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
