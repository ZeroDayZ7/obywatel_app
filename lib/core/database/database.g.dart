// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CryptoKeysTable extends CryptoKeys
    with TableInfo<$CryptoKeysTable, CryptoKey> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CryptoKeysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _privateKeyMeta = const VerificationMeta(
    'privateKey',
  );
  @override
  late final GeneratedColumn<Uint8List> privateKey = GeneratedColumn<Uint8List>(
    'private_key',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _publicKeyMeta = const VerificationMeta(
    'publicKey',
  );
  @override
  late final GeneratedColumn<Uint8List> publicKey = GeneratedColumn<Uint8List>(
    'public_key',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, privateKey, publicKey, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'crypto_keys';
  @override
  VerificationContext validateIntegrity(
    Insertable<CryptoKey> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('private_key')) {
      context.handle(
        _privateKeyMeta,
        privateKey.isAcceptableOrUnknown(data['private_key']!, _privateKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_privateKeyMeta);
    }
    if (data.containsKey('public_key')) {
      context.handle(
        _publicKeyMeta,
        publicKey.isAcceptableOrUnknown(data['public_key']!, _publicKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_publicKeyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CryptoKey map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CryptoKey(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      privateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}private_key'],
      )!,
      publicKey: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}public_key'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CryptoKeysTable createAlias(String alias) {
    return $CryptoKeysTable(attachedDatabase, alias);
  }
}

class CryptoKey extends DataClass implements Insertable<CryptoKey> {
  final String id;
  final Uint8List privateKey;
  final Uint8List publicKey;
  final DateTime createdAt;
  const CryptoKey({
    required this.id,
    required this.privateKey,
    required this.publicKey,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['private_key'] = Variable<Uint8List>(privateKey);
    map['public_key'] = Variable<Uint8List>(publicKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CryptoKeysCompanion toCompanion(bool nullToAbsent) {
    return CryptoKeysCompanion(
      id: Value(id),
      privateKey: Value(privateKey),
      publicKey: Value(publicKey),
      createdAt: Value(createdAt),
    );
  }

  factory CryptoKey.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CryptoKey(
      id: serializer.fromJson<String>(json['id']),
      privateKey: serializer.fromJson<Uint8List>(json['privateKey']),
      publicKey: serializer.fromJson<Uint8List>(json['publicKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'privateKey': serializer.toJson<Uint8List>(privateKey),
      'publicKey': serializer.toJson<Uint8List>(publicKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CryptoKey copyWith({
    String? id,
    Uint8List? privateKey,
    Uint8List? publicKey,
    DateTime? createdAt,
  }) => CryptoKey(
    id: id ?? this.id,
    privateKey: privateKey ?? this.privateKey,
    publicKey: publicKey ?? this.publicKey,
    createdAt: createdAt ?? this.createdAt,
  );
  CryptoKey copyWithCompanion(CryptoKeysCompanion data) {
    return CryptoKey(
      id: data.id.present ? data.id.value : this.id,
      privateKey: data.privateKey.present
          ? data.privateKey.value
          : this.privateKey,
      publicKey: data.publicKey.present ? data.publicKey.value : this.publicKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CryptoKey(')
          ..write('id: $id, ')
          ..write('privateKey: $privateKey, ')
          ..write('publicKey: $publicKey, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    $driftBlobEquality.hash(privateKey),
    $driftBlobEquality.hash(publicKey),
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CryptoKey &&
          other.id == this.id &&
          $driftBlobEquality.equals(other.privateKey, this.privateKey) &&
          $driftBlobEquality.equals(other.publicKey, this.publicKey) &&
          other.createdAt == this.createdAt);
}

class CryptoKeysCompanion extends UpdateCompanion<CryptoKey> {
  final Value<String> id;
  final Value<Uint8List> privateKey;
  final Value<Uint8List> publicKey;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CryptoKeysCompanion({
    this.id = const Value.absent(),
    this.privateKey = const Value.absent(),
    this.publicKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CryptoKeysCompanion.insert({
    required String id,
    required Uint8List privateKey,
    required Uint8List publicKey,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       privateKey = Value(privateKey),
       publicKey = Value(publicKey);
  static Insertable<CryptoKey> custom({
    Expression<String>? id,
    Expression<Uint8List>? privateKey,
    Expression<Uint8List>? publicKey,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (privateKey != null) 'private_key': privateKey,
      if (publicKey != null) 'public_key': publicKey,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CryptoKeysCompanion copyWith({
    Value<String>? id,
    Value<Uint8List>? privateKey,
    Value<Uint8List>? publicKey,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CryptoKeysCompanion(
      id: id ?? this.id,
      privateKey: privateKey ?? this.privateKey,
      publicKey: publicKey ?? this.publicKey,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (privateKey.present) {
      map['private_key'] = Variable<Uint8List>(privateKey.value);
    }
    if (publicKey.present) {
      map['public_key'] = Variable<Uint8List>(publicKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CryptoKeysCompanion(')
          ..write('id: $id, ')
          ..write('privateKey: $privateKey, ')
          ..write('publicKey: $publicKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CryptoKeysTable cryptoKeys = $CryptoKeysTable(this);
  late final CryptoKeysDao cryptoKeysDao = CryptoKeysDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cryptoKeys];
}

typedef $$CryptoKeysTableCreateCompanionBuilder =
    CryptoKeysCompanion Function({
      required String id,
      required Uint8List privateKey,
      required Uint8List publicKey,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$CryptoKeysTableUpdateCompanionBuilder =
    CryptoKeysCompanion Function({
      Value<String> id,
      Value<Uint8List> privateKey,
      Value<Uint8List> publicKey,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CryptoKeysTableFilterComposer
    extends Composer<_$AppDatabase, $CryptoKeysTable> {
  $$CryptoKeysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get privateKey => $composableBuilder(
    column: $table.privateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get publicKey => $composableBuilder(
    column: $table.publicKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CryptoKeysTableOrderingComposer
    extends Composer<_$AppDatabase, $CryptoKeysTable> {
  $$CryptoKeysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get privateKey => $composableBuilder(
    column: $table.privateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get publicKey => $composableBuilder(
    column: $table.publicKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CryptoKeysTableAnnotationComposer
    extends Composer<_$AppDatabase, $CryptoKeysTable> {
  $$CryptoKeysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<Uint8List> get privateKey => $composableBuilder(
    column: $table.privateKey,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get publicKey =>
      $composableBuilder(column: $table.publicKey, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CryptoKeysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CryptoKeysTable,
          CryptoKey,
          $$CryptoKeysTableFilterComposer,
          $$CryptoKeysTableOrderingComposer,
          $$CryptoKeysTableAnnotationComposer,
          $$CryptoKeysTableCreateCompanionBuilder,
          $$CryptoKeysTableUpdateCompanionBuilder,
          (
            CryptoKey,
            BaseReferences<_$AppDatabase, $CryptoKeysTable, CryptoKey>,
          ),
          CryptoKey,
          PrefetchHooks Function()
        > {
  $$CryptoKeysTableTableManager(_$AppDatabase db, $CryptoKeysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CryptoKeysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CryptoKeysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CryptoKeysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<Uint8List> privateKey = const Value.absent(),
                Value<Uint8List> publicKey = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CryptoKeysCompanion(
                id: id,
                privateKey: privateKey,
                publicKey: publicKey,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required Uint8List privateKey,
                required Uint8List publicKey,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CryptoKeysCompanion.insert(
                id: id,
                privateKey: privateKey,
                publicKey: publicKey,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CryptoKeysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CryptoKeysTable,
      CryptoKey,
      $$CryptoKeysTableFilterComposer,
      $$CryptoKeysTableOrderingComposer,
      $$CryptoKeysTableAnnotationComposer,
      $$CryptoKeysTableCreateCompanionBuilder,
      $$CryptoKeysTableUpdateCompanionBuilder,
      (CryptoKey, BaseReferences<_$AppDatabase, $CryptoKeysTable, CryptoKey>),
      CryptoKey,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CryptoKeysTableTableManager get cryptoKeys =>
      $$CryptoKeysTableTableManager(_db, _db.cryptoKeys);
}
