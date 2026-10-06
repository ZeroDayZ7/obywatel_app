import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/tables/user_documents.dart';

part 'user_documents_dao.g.dart';

@DriftAccessor(tables: [UserDocuments])
class UserDocumentsDao extends DatabaseAccessor<AppDatabase>
    with _$UserDocumentsDaoMixin {
  UserDocumentsDao(super.db);

  // Reaktywny stream wszystkich nieusuniętych dokumentów.
  // Status (active/expired/revoked) jest wykorzystywany do prezentacji, nie do filtrowania listy.
  Stream<List<DbUserDocument>> watchDocuments() {
    return (select(userDocuments)
          ..where((t) => t.deletedAt.isNull())
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

  Future<String?> getDocumentManifestHash(String id) async {
    final row = await (select(
      userDocuments,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;

    final payload = {
      'id': row.id,
      'typeCode': row.typeCode,
      'status': row.status,
      'title': row.title,
      'issuer': row.issuer,
      'category': row.category,
      'documentNumber': row.documentNumber,
      'issuerSignature': base64.encode(row.issuerSignature),
      'signingKeyId': row.signingKeyId,
      'revocationSerial': row.revocationSerial,
      'version': row.version,
      'issuedAt': row.issuedAt?.toIso8601String(),
      'expiresAt': row.expiresAt?.toIso8601String(),
      'customAttributesJson': row.customAttributesJson,
      'allowedScopesJson': row.allowedScopesJson,
      'updatedAt': row.updatedAt.toIso8601String(),
    };

    final json = jsonEncode(payload);
    final digest = sha256.convert(utf8.encode(json));
    return digest.toString();
  }

  // Synchronizacja różnicowa (Delta Sync) z backendu
  Future<void> upsertDocuments(List<UserDocumentsCompanion> docs) async {
    if (docs.isEmpty) return;

    await batch((batch) {
      batch.insertAll(userDocuments, docs, mode: InsertMode.insertOrReplace);
    });
  }

  // Usunięcie lokalne (Soft Delete lub Hard Delete przy czyszczeniu profilu)
  Future<int> deleteDocument(String id) {
    return (delete(userDocuments)..where((t) => t.id.equals(id))).go();
  }
}
