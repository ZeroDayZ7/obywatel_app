// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_keys_dao.dart';

// ignore_for_file: type=lint
mixin _$CryptoKeysDaoMixin on DatabaseAccessor<AppDatabase> {
  $CryptoKeysTable get cryptoKeys => attachedDatabase.cryptoKeys;
  CryptoKeysDaoManager get managers => CryptoKeysDaoManager(this);
}

class CryptoKeysDaoManager {
  final _$CryptoKeysDaoMixin _db;
  CryptoKeysDaoManager(this._db);
  $$CryptoKeysTableTableManager get cryptoKeys =>
      $$CryptoKeysTableTableManager(_db.attachedDatabase, _db.cryptoKeys);
}
