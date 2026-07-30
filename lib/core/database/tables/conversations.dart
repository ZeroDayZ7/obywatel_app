import 'package:drift/drift.dart';

@DataClassName('ConversationEntity')
class Conversations extends Table {
  TextColumn get id => text()();
  
  // Typ konwersacji: 'direct', 'group'
  TextColumn get type => text().withDefault(const Constant('direct'))();
  
  // Opcjonalny tytuł dla grup (może być zaszyfrowany)
  TextColumn get title => text().nullable()();
  
  // Monotoniczna sekwencja do śledzenia spójności wątku
Int64Column get lastSequence => int64().withDefault(Constant(BigInt.zero))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}