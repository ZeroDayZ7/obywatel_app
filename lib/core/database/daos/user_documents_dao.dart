import 'package:drift/drift.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/tables/user_documents.dart';

part 'user_documents_dao.g.dart';

@DriftAccessor(tables: [UserDocuments])
class UserDocumentsDao extends DatabaseAccessor<AppDatabase>
    with _$UserDocumentsDaoMixin {
  UserDocumentsDao(super.db);

  // Reaktywny stream aktywnych dokumentów (zmieniono && na &)
  Stream<List<DbUserDocument>> watchActiveDocuments() {
    return (select(userDocuments)
          ..where((t) => t.deletedAt.isNull() & t.status.equals('active'))
          ..orderBy([(t) => OrderingTerm.asc(t.title)]))
        .watch();
  }

  // Pobieranie pojedynczego dokumentu po ID
  Future<DbUserDocument?> getDocumentById(String id) {
    return (select(
      userDocuments,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // Wyciąganie najwyższej posiadanej wersji dokumentów (dla odpytania backendu o since_version)
  Future<int> getMaxVersion() async {
    final maxVersionExpr = userDocuments.version.max();
    final query = selectOnly(userDocuments)..addColumns([maxVersionExpr]);
    final result = await query
        .map((row) => row.read(maxVersionExpr))
        .getSingleOrNull();
    return result ?? 0;
  }

  // Synchronizacja różnicowa (Delta Sync) z backendu
  Future<void> upsertDocuments(List<UserDocumentsCompanion> docs) async {
    await batch((batch) {
      batch.insertAll(userDocuments, docs, mode: InsertMode.insertOrReplace);
    });
  }

  // Usunięcie lokalne (Soft Delete lub Hard Delete przy czyszczeniu profilu)
  Future<int> deleteDocument(String id) {
    return (delete(userDocuments)..where((t) => t.id.equals(id))).go();
  }
}
