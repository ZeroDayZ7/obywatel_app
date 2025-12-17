import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'tables/crypto_keys.dart';
import 'daos/crypto_keys_dao.dart';

part 'database.g.dart';

@DriftDatabase(tables: [CryptoKeys], daos: [CryptoKeysDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final file = File('app.sqlite');
    return NativeDatabase.createInBackground(file);
  });
}
