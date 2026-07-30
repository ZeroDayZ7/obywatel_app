import 'package:drift/drift.dart';

@DataClassName('ConversationMemberEntity')
class ConversationMembers extends Table {
  TextColumn get id => text()();
  TextColumn get conversationId => text()();
  TextColumn get userId => text()();
  
  // Rola użytkownika: 'admin', 'member'
  TextColumn get role => text().withDefault(const Constant('member'))();
  
  // Ostatnia przeczytana sekwencja wiadomości przez członka
Int64Column get lastReadSequence => int64().withDefault(Constant(BigInt.zero))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}