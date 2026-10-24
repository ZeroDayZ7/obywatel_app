import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/tables/crypto_keys.dart';

part 'crypto_keys_dao.g.dart';

@DriftAccessor(tables: [CryptoKeys])
class CryptoKeysDao extends DatabaseAccessor<AppDatabase>
    with _$CryptoKeysDaoMixin {
  CryptoKeysDao(super.db);

  Future<void> insertOrUpdateKey({
    required String id,
    required Uint8List privateKey,
    required Uint8List publicKey,
  }) async {
    await into(cryptoKeys).insertOnConflictUpdate(
      CryptoKeysCompanion(
        id: Value(id),
        privateKey: Value(privateKey),
        publicKey: Value(publicKey),
      ),
    );
  }

  Future<CryptoKey?> getKey(String id) =>
      (select(cryptoKeys)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> saveAttachmentKey({
    required String attachmentId,
    required Uint8List keyBytes,
  }) async {
    await into(cryptoKeys).insertOnConflictUpdate(
      CryptoKeysCompanion(
        id: Value('attachment:$attachmentId'),
        privateKey: Value(keyBytes),
        publicKey: Value(Uint8List(0)),
      ),
    );
  }

  Future<String?> getAttachmentKey(String attachmentId) async {
    final row = await getKey('attachment:$attachmentId');
    if (row == null || row.privateKey.isEmpty) {
      return null;
    }
    return base64Encode(row.privateKey);
  }

  Future<int> deleteKey(String id) =>
      (delete(cryptoKeys)..where((t) => t.id.equals(id))).go();

  Future<int> deleteAttachmentKey(String attachmentId) =>
      deleteKey('attachment:$attachmentId');
}
