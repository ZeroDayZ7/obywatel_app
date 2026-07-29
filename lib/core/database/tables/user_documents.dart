import 'package:drift/drift.dart';

@DataClassName('DbUserDocument')
class UserDocuments extends Table {
  TextColumn get id => text()();
  TextColumn get typeCode => text().withLength(max: 64)();
  TextColumn get status =>
      text().withLength(max: 20).withDefault(const Constant('active'))();

  // Odszyfrowane metadane i wizerunek (JSON / Szczegóły)
  TextColumn get title => text()();
  TextColumn get issuer => text()();
  TextColumn get category => text()();
  TextColumn get documentNumber => text()();

  // Przechowywanie dynamicznych atrybutów jako String (JSON)
  TextColumn get customAttributesJson => text().nullable()();
  TextColumn get allowedScopesJson => text().nullable()();

  // Podpis kryptograficzny wydawcy i serial unieważnienia (dla Offline QR)
  BlobColumn get issuerSignature => blob()();
  TextColumn get signingKeyId => text()();
  TextColumn get revocationSerial => text()();

  // Wersjonowanie dla Delta Sync
  IntColumn get version => integer().withDefault(const Constant(1))();

  // Daty ważności
  DateTimeColumn get issuedAt => dateTime().nullable()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
