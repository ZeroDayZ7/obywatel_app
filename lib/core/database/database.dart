import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:obywatel_plus/core/storage/secure_storage_service.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/crypto_keys_dao.dart';
import 'tables/crypto_keys.dart';

part 'database.g.dart';

@DriftDatabase(tables: [CryptoKeys], daos: [CryptoKeysDao])
class AppDatabase extends _$AppDatabase {
  final SecureStorageService storage;

  // Przekazujemy storage do konstruktora
  AppDatabase(this.storage) : super(_openConnection(storage));

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection(SecureStorageService storage) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_encrypted.sqlite'));

    // 1. Pobierz lub wygeneruj klucz szyfrujący
    String? encryptionKey = await storage.read(key: StorageKeys.databaseKey);

    if (encryptionKey == null) {
      // Generujemy bezpieczny, losowy ciąg 32 znaków
      final values = List<int>.generate(
        32,
        (i) => Random.secure().nextInt(256),
      );
      encryptionKey = base64Url.encode(values);
      await storage.write(key: StorageKeys.databaseKey, value: encryptionKey);
    }

    // 2. Otwórz bazę z SQLCipher
    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) {
        // SQLCipher wymaga ustawienia klucza PRZED jakimkolwiek zapytaniem
        rawDb.execute("PRAGMA key = '$encryptionKey';");
      },
    );
  });
}
