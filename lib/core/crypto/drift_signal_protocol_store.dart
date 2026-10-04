import 'dart:async';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:obywatel_plus/core/database/database.dart';

class DriftSignalProtocolStore implements SignalProtocolStore {
  DriftSignalProtocolStore(
    this.db, {
    IdentityKeyPair? identityKeyPair,
    int? localRegistrationId,
  })  : _identityKeyPair = identityKeyPair ?? generateIdentityKeyPair(),
        _localRegistrationId =
            localRegistrationId ?? generateRegistrationId(false) {
    unawaited(_persistLocalIdentity());
  }

  final AppDatabase db;
  final IdentityKeyPair _identityKeyPair;
  final int _localRegistrationId;

  Future<void> _persistLocalIdentity() async {
    final existing = await _loadLocalIdentity();
    final payload = _identityKeyPair.serialize();

    if (existing == null) {
      await db.into(db.signalLocalIdentity).insert(
        SignalLocalIdentityCompanion(
          id: const Value('local'),
          identityKeyPair: Value(payload),
          registrationId: Value(_localRegistrationId),
        ),
      );
      return;
    }

    if (existing.registrationId != _localRegistrationId ||
        !const ListEquality<int>().equals(existing.identityKeyPair, payload)) {
      await (db.update(db.signalLocalIdentity)
            ..where((row) => row.id.equals('local')))
          .write(
        SignalLocalIdentityCompanion(
          id: const Value('local'),
          identityKeyPair: Value(payload),
          registrationId: Value(_localRegistrationId),
        ),
      );
    }
  }

  Future<SignalLocalIdentityData?> _loadLocalIdentity() async {
    return (db.select(db.signalLocalIdentity)
          ..where((row) => row.id.equals('local')))
        .getSingleOrNull();
  }

  @override
  Future<IdentityKeyPair> getIdentityKeyPair() async {
    final row = await _loadLocalIdentity();
    if (row != null) {
      return IdentityKeyPair.fromSerialized(row.identityKeyPair);
    }
    return _identityKeyPair;
  }

  @override
  Future<int> getLocalRegistrationId() async {
    final row = await _loadLocalIdentity();
    if (row != null) {
      return row.registrationId;
    }
    return _localRegistrationId;
  }

  @override
  Future<bool> saveIdentity(
    SignalProtocolAddress address,
    IdentityKey? identityKey,
  ) async {
    if (identityKey == null) {
      return false;
    }

    final current = await getIdentity(address);
    final serialized = identityKey.serialize();
    if (current != null &&
        const ListEquality<int>().equals(current.serialize(), serialized)) {
      return false;
    }

    await db.into(db.signalIdentityKeys).insertOnConflictUpdate(
      SignalIdentityKeysCompanion(
        name: Value(address.getName()),
        deviceId: Value(address.getDeviceId()),
        identityKey: Value(serialized),
      ),
    );

    return true;
  }

  @override
  Future<bool> isTrustedIdentity(
    SignalProtocolAddress address,
    IdentityKey? identityKey,
    Direction direction,
  ) async {
    if (identityKey == null) {
      return false;
    }

    final trusted = await getIdentity(address);
    if (trusted == null) {
      return true;
    }

    return const ListEquality<int>()
        .equals(trusted.serialize(), identityKey.serialize());
  }

  @override
  Future<IdentityKey?> getIdentity(SignalProtocolAddress address) async {
    final row = (db.select(db.signalIdentityKeys)
          ..where(
            (entry) =>
                entry.name.equals(address.getName()) &
                entry.deviceId.equals(address.getDeviceId()),
          ))
        .getSingleOrNull();

    final result = await row;
    if (result == null) {
      return null;
    }

    return IdentityKey.fromBytes(result.identityKey, 0);
  }

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async {
    final row = (db.select(db.signalPreKeys)
          ..where((entry) => entry.id.equals(preKeyId)))
        .getSingleOrNull();

    final record = await row;
    if (record == null) {
      throw InvalidKeyIdException('Missing pre-key: $preKeyId');
    }

    return PreKeyRecord.fromBuffer(record.record);
  }

  @override
  Future<void> storePreKey(int preKeyId, PreKeyRecord record) async {
    await db.into(db.signalPreKeys).insertOnConflictUpdate(
      SignalPreKeysCompanion(
        id: Value(preKeyId),
        record: Value(record.serialize()),
      ),
    );
  }

  @override
  Future<bool> containsPreKey(int preKeyId) async {
    final row = (db.select(db.signalPreKeys)
          ..where((entry) => entry.id.equals(preKeyId)))
        .getSingleOrNull();
    return await row != null;
  }

  @override
  Future<void> removePreKey(int preKeyId) async {
    await (db.delete(db.signalPreKeys)
          ..where((entry) => entry.id.equals(preKeyId)))
        .go();
  }

  @override
  Future<SessionRecord> loadSession(SignalProtocolAddress address) async {
    final row = (db.select(db.signalSessions)
          ..where(
            (entry) =>
                entry.name.equals(address.getName()) &
                entry.deviceId.equals(address.getDeviceId()),
          ))
        .getSingleOrNull();

    final result = await row;
    if (result == null) {
      return SessionRecord();
    }

    return SessionRecord.fromSerialized(result.record);
  }

  @override
  Future<List<int>> getSubDeviceSessions(String name) async {
    final rows = await (db.select(db.signalSessions)
          ..where((entry) => entry.name.equals(name) & entry.deviceId.isNotNull()))
        .get();

    return rows
        .where((row) => row.deviceId != 1)
        .map((row) => row.deviceId)
        .toList();
  }

  @override
  Future<void> storeSession(
    SignalProtocolAddress address,
    SessionRecord record,
  ) async {
    await db.into(db.signalSessions).insertOnConflictUpdate(
      SignalSessionsCompanion(
        name: Value(address.getName()),
        deviceId: Value(address.getDeviceId()),
        record: Value(record.serialize()),
      ),
    );
  }

  @override
  Future<bool> containsSession(SignalProtocolAddress address) async {
    final row = (db.select(db.signalSessions)
          ..where(
            (entry) =>
                entry.name.equals(address.getName()) &
                entry.deviceId.equals(address.getDeviceId()),
          ))
        .getSingleOrNull();
    return await row != null;
  }

  @override
  Future<void> deleteSession(SignalProtocolAddress address) async {
    await (db.delete(db.signalSessions)
          ..where(
            (entry) =>
                entry.name.equals(address.getName()) &
                entry.deviceId.equals(address.getDeviceId()),
          ))
        .go();
  }

  @override
  Future<void> deleteAllSessions(String name) async {
    await (db.delete(db.signalSessions)
          ..where((entry) => entry.name.equals(name)))
        .go();
  }

  @override
  Future<SignedPreKeyRecord> loadSignedPreKey(int signedPreKeyId) async {
    final row = (db.select(db.signalSignedPreKeys)
          ..where((entry) => entry.id.equals(signedPreKeyId)))
        .getSingleOrNull();

    final result = await row;
    if (result == null) {
      throw InvalidKeyIdException('Missing signed pre-key: $signedPreKeyId');
    }

    return SignedPreKeyRecord.fromSerialized(result.record);
  }

  @override
  Future<List<SignedPreKeyRecord>> loadSignedPreKeys() async {
    final rows = await db.select(db.signalSignedPreKeys).get();
    return rows
        .map((row) => SignedPreKeyRecord.fromSerialized(row.record))
        .toList();
  }

  @override
  Future<void> storeSignedPreKey(
    int signedPreKeyId,
    SignedPreKeyRecord record,
  ) async {
    await db.into(db.signalSignedPreKeys).insertOnConflictUpdate(
      SignalSignedPreKeysCompanion(
        id: Value(signedPreKeyId),
        record: Value(record.serialize()),
      ),
    );
  }

  @override
  Future<bool> containsSignedPreKey(int signedPreKeyId) async {
    final row = (db.select(db.signalSignedPreKeys)
          ..where((entry) => entry.id.equals(signedPreKeyId)))
        .getSingleOrNull();
    return await row != null;
  }

  @override
  Future<void> removeSignedPreKey(int signedPreKeyId) async {
    await (db.delete(db.signalSignedPreKeys)
          ..where((entry) => entry.id.equals(signedPreKeyId)))
        .go();
  }
}
