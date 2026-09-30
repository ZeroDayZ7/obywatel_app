// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_documents_dao.dart';

// ignore_for_file: type=lint
mixin _$UserDocumentsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UserDocumentsTable get userDocuments => attachedDatabase.userDocuments;
  UserDocumentsDaoManager get managers => UserDocumentsDaoManager(this);
}

class UserDocumentsDaoManager {
  final _$UserDocumentsDaoMixin _db;
  UserDocumentsDaoManager(this._db);
  $$UserDocumentsTableTableManager get userDocuments =>
      $$UserDocumentsTableTableManager(_db.attachedDatabase, _db.userDocuments);
}
