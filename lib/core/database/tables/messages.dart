import 'package:drift/drift.dart';

@DataClassName('MessageEntity')
class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get conversationId => text()();
  TextColumn get senderId => text()();
  TextColumn get senderDeviceId => text()();
  
  // Typ wiadomości: 'text', 'media', 'system'
  TextColumn get type => text().withDefault(const Constant('text'))();
  
  // Monotoniczny numer sekwencyjny w danej konwersacji
  Int64Column get sequence => int64()();
  
  // Zaszyfrowany ładunek wiadomości (AES-GCM / Signal Protocol)
  BlobColumn get encryptedPayload => blob()();
  
  // Opcjonalne meta-dane załącznika (S3 key, iv, thumbnail)
  BlobColumn get mediaHeader => blob().nullable()();
  
  // Globalny wskaźnik wersji w mikroserwisie do synchronizacji Delta Sync
  Int64Column get version => int64().withDefault(Constant(BigInt.from(1)))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}