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
    unawaited(_ensureLocalIdentityLoaded());
  }

  final AppDatabase db;
  IdentityKeyPair _identityKeyPair;
  int _localRegistrationId;
  bool _localIdentityLoaded = false;
  Future<void>? _localIdentityLoading;

  Future<void> _ensureLocalIdentityLoaded() async {
    if (_localIdentityLoaded) {
      return;
    }

    if (_localIdentityLoading != null) {
      await _localIdentityLoading;
      return;
    }

    _localIdentityLoading = () async {
      final existing = await _loadLocalIdentity();
      if (existing != null) {
        _identityKeyPair = IdentityKeyPair.fromSerialized(existing.identityKeyPair);
        _localRegistrationId = existing.registrationId;
        _localIdentityLoaded = true;
        return;
      }

      await db.into(db.signalLocalIdentity).insert(
        SignalLocalIdentityCompanion(
          id: const Value('local'),
          identityKeyPair: Value(_identityKeyPair.serialize()),
          registrationId: Value(_localRegistrationId),
        ),
      );
      _localIdentityLoaded = true;
    }();

    try {
      await _localIdentityLoading;
    } finally {
      _localIdentityLoading = null;
    }
  }


  Future<SignalLocalIdentityData?> _loadLocalIdentity() async {
    return (db.select(db.signalLocalIdentity)
          ..where((row) => row.id.equals('local')))
        .getSingleOrNull();
  }

  @override
  Future<IdentityKeyPair> getIdentityKeyPair() async {
    final startedAt = DateTime.now();
    try {
      await _ensureLocalIdentityLoaded();
      return _identityKeyPair;
    } catch (error, stackTrace) {
      print(
        '[E2EE_TRACE] stage=store_local_identity_read_error event=error error_type=${error.runtimeType} error_message=${error.toString()}',
      );
      print(stackTrace);
      rethrow;
    } finally {
      final durationMs = DateTime.now().difference(startedAt).inMilliseconds;
      print('[E2EE_TRACE] stage=store_local_identity_read event=complete duration_ms=$durationMs');
    }
  }

  @override
  Future<int> getLocalRegistrationId() async {
    await _ensureLocalIdentityLoaded();
    return _localRegistrationId;
  }

  @override
  Future<bool> saveIdentity(
    SignalProtocolAddress address,
    IdentityKey? identityKey,
  ) async {
    final startedAt = DateTime.now();
    if (identityKey == null) {
      print(
        '[E2EE_TRACE] stage=store_identity_save_skipped event=warning signal_address=${address.getName()}@${address.getDeviceId()} reason=identity_null',
      );
      return false;
    }

    try {
      final current = await getIdentity(address);
      final serialized = identityKey.serialize();
      if (current != null &&
          const ListEquality<int>().equals(current.serialize(), serialized)) {
        print(
          '[E2EE_TRACE] stage=store_identity_save_unchanged event=success signal_address=${address.getName()}@${address.getDeviceId()} identity_bytes=${serialized.length}',
        );
        return false;
      }

      await db.into(db.signalIdentityKeys).insertOnConflictUpdate(
        SignalIdentityKeysCompanion(
          name: Value(address.getName()),
          deviceId: Value(address.getDeviceId()),
          identityKey: Value(serialized),
        ),
      );

      print(
        '[E2EE_TRACE] stage=store_identity_save event=success signal_address=${address.getName()}@${address.getDeviceId()} identity_bytes=${serialized.length}',
      );
      return true;
    } catch (error, stackTrace) {
      print(
        '[E2EE_TRACE] stage=store_identity_save_error event=error signal_address=${address.getName()}@${address.getDeviceId()} error_type=${error.runtimeType} error_message=${error.toString()}',
      );
      print(stackTrace);
      rethrow;
    } finally {
      final durationMs = DateTime.now().difference(startedAt).inMilliseconds;
      print(
        '[E2EE_TRACE] stage=store_identity_save_complete event=complete signal_address=${address.getName()}@${address.getDeviceId()} duration_ms=$durationMs',
      );
    }
  }

  @override
  Future<bool> isTrustedIdentity(
    SignalProtocolAddress address,
    IdentityKey? identityKey,
    Direction direction,
  ) async {
    final startedAt = DateTime.now();
    if (identityKey == null) {
      print(
        '[E2EE_TRACE] stage=identity_trust_check event=warning signal_address=${address.getName()}@${address.getDeviceId()} direction=${direction.name} result=false reason=identity_null',
      );
      return false;
    }

    try {
      final trusted = await getIdentity(address);
      final result = trusted == null ||
          const ListEquality<int>().equals(
            trusted.serialize(),
            identityKey.serialize(),
          );
      print(
        '[E2EE_TRACE] stage=identity_trust_check event=success signal_address=${address.getName()}@${address.getDeviceId()} direction=${direction.name} result=$result trusted_present=${trusted != null}',
      );
      return result;
    } catch (error, stackTrace) {
      print(
        '[E2EE_TRACE] stage=identity_trust_check_error event=error signal_address=${address.getName()}@${address.getDeviceId()} direction=${direction.name} error_type=${error.runtimeType} error_message=${error.toString()}',
      );
      print(stackTrace);
      rethrow;
    } finally {
      final durationMs = DateTime.now().difference(startedAt).inMilliseconds;
      print(
        '[E2EE_TRACE] stage=identity_trust_check_complete event=complete signal_address=${address.getName()}@${address.getDeviceId()} duration_ms=$durationMs',
      );
    }
  }

  @override
  Future<IdentityKey?> getIdentity(SignalProtocolAddress address) async {
    final startedAt = DateTime.now();
    try {
      final row = (db.select(db.signalIdentityKeys)
            ..where(
              (entry) =>
                  entry.name.equals(address.getName()) &
                  entry.deviceId.equals(address.getDeviceId()),
            ))
          .getSingleOrNull();

      final result = await row;
      if (result == null) {
        print(
          '[E2EE_TRACE] stage=identity_read_missing event=success signal_address=${address.getName()}@${address.getDeviceId()} result=missing',
        );
        return null;
      }

      final key = IdentityKey.fromBytes(result.identityKey, 0);
      print(
        '[E2EE_TRACE] stage=identity_read event=success signal_address=${address.getName()}@${address.getDeviceId()} identity_bytes=${result.identityKey.length}',
      );
      return key;
    } catch (error, stackTrace) {
      print(
        '[E2EE_TRACE] stage=identity_read_error event=error signal_address=${address.getName()}@${address.getDeviceId()} error_type=${error.runtimeType} error_message=${error.toString()}',
      );
      print(stackTrace);
      rethrow;
    } finally {
      final durationMs = DateTime.now().difference(startedAt).inMilliseconds;
      print(
        '[E2EE_TRACE] stage=identity_read_complete event=complete signal_address=${address.getName()}@${address.getDeviceId()} duration_ms=$durationMs',
      );
    }
  }

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async {
    final startedAt = DateTime.now();
    try {
      final row = (db.select(db.signalPreKeys)
            ..where((entry) => entry.id.equals(preKeyId)))
          .getSingleOrNull();

      final record = await row;
      if (record == null) {
        throw InvalidKeyIdException('Missing pre-key: $preKeyId');
      }

      final preKey = PreKeyRecord.fromBuffer(record.record);
      print(
        '[E2EE_TRACE] stage=prekey_load event=success pre_key_id=$preKeyId record_bytes=${record.record.length}',
      );
      return preKey;
    } catch (error, stackTrace) {
      print(
        '[E2EE_TRACE] stage=prekey_load_error event=error pre_key_id=$preKeyId error_type=${error.runtimeType} error_message=${error.toString()}',
      );
      print(stackTrace);
      rethrow;
    } finally {
      final durationMs = DateTime.now().difference(startedAt).inMilliseconds;
      print('[E2EE_TRACE] stage=prekey_load_complete event=complete pre_key_id=$preKeyId duration_ms=$durationMs');
    }
  }

  @override
  Future<void> storePreKey(int preKeyId, PreKeyRecord record) async {
    final startedAt = DateTime.now();
    final serialized = record.serialize();
    try {
      await db.into(db.signalPreKeys).insertOnConflictUpdate(
        SignalPreKeysCompanion(
          id: Value(preKeyId),
          record: Value(serialized),
        ),
      );
      print(
        '[E2EE_TRACE] stage=prekey_store event=success pre_key_id=$preKeyId record_bytes=${serialized.length}',
      );
    } catch (error, stackTrace) {
      print(
        '[E2EE_TRACE] stage=prekey_store_error event=error pre_key_id=$preKeyId error_type=${error.runtimeType} error_message=${error.toString()}',
      );
      print(stackTrace);
      rethrow;
    } finally {
      final durationMs = DateTime.now().difference(startedAt).inMilliseconds;
      print('[E2EE_TRACE] stage=prekey_store_complete event=complete pre_key_id=$preKeyId duration_ms=$durationMs');
    }
  }

  @override
  Future<bool> containsPreKey(int preKeyId) async {
    final startedAt = DateTime.now();
    try {
      final row = (db.select(db.signalPreKeys)
            ..where((entry) => entry.id.equals(preKeyId)))
          .getSingleOrNull();
      final exists = await row != null;
      print(
        '[E2EE_TRACE] stage=prekey_contains event=success pre_key_id=$preKeyId exists=$exists',
      );
      return exists;
    } catch (error, stackTrace) {
      print(
        '[E2EE_TRACE] stage=prekey_contains_error event=error pre_key_id=$preKeyId error_type=${error.runtimeType} error_message=${error.toString()}',
      );
      print(stackTrace);
      rethrow;
    } finally {
      final durationMs = DateTime.now().difference(startedAt).inMilliseconds;
      print('[E2EE_TRACE] stage=prekey_contains_complete event=complete pre_key_id=$preKeyId duration_ms=$durationMs');
    }
  }

  @override
  Future<void> removePreKey(int preKeyId) async {
    await (db.delete(db.signalPreKeys)
          ..where((entry) => entry.id.equals(preKeyId)))
        .go();
  }

  @override
  Future<SessionRecord> loadSession(SignalProtocolAddress address) async {
    final startedAt = DateTime.now();
    try {
      final row = (db.select(db.signalSessions)
            ..where(
              (entry) =>
                  entry.name.equals(address.getName()) &
                  entry.deviceId.equals(address.getDeviceId()),
            ))
          .getSingleOrNull();

      final result = await row;
      if (result == null) {
        print(
          '[E2EE_TRACE] stage=session_load_missing event=success signal_address=${address.getName()}@${address.getDeviceId()} result=missing',
        );
        return SessionRecord();
      }

      final session = SessionRecord.fromSerialized(result.record);
      print(
        '[E2EE_TRACE] stage=session_load event=success signal_address=${address.getName()}@${address.getDeviceId()} record_bytes=${result.record.length}',
      );
      return session;
    } catch (error, stackTrace) {
      print(
        '[E2EE_TRACE] stage=session_load_error event=error signal_address=${address.getName()}@${address.getDeviceId()} error_type=${error.runtimeType} error_message=${error.toString()}',
      );
      print(stackTrace);
      rethrow;
    } finally {
      final durationMs = DateTime.now().difference(startedAt).inMilliseconds;
      print(
        '[E2EE_TRACE] stage=session_load_complete event=complete signal_address=${address.getName()}@${address.getDeviceId()} duration_ms=$durationMs',
      );
    }
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
    final startedAt = DateTime.now();
    final serialized = record.serialize();
    try {
      await db.into(db.signalSessions).insertOnConflictUpdate(
        SignalSessionsCompanion(
          name: Value(address.getName()),
          deviceId: Value(address.getDeviceId()),
          record: Value(serialized),
        ),
      );
      print(
        '[E2EE_TRACE] stage=session_store event=success signal_address=${address.getName()}@${address.getDeviceId()} record_bytes=${serialized.length}',
      );
    } catch (error, stackTrace) {
      print(
        '[E2EE_TRACE] stage=session_store_error event=error signal_address=${address.getName()}@${address.getDeviceId()} error_type=${error.runtimeType} error_message=${error.toString()}',
      );
      print(stackTrace);
      rethrow;
    } finally {
      final durationMs = DateTime.now().difference(startedAt).inMilliseconds;
      print(
        '[E2EE_TRACE] stage=session_store_complete event=complete signal_address=${address.getName()}@${address.getDeviceId()} duration_ms=$durationMs',
      );
    }
  }

  @override
  Future<bool> containsSession(SignalProtocolAddress address) async {
    final startedAt = DateTime.now();
    try {
      final row = (db.select(db.signalSessions)
            ..where(
              (entry) =>
                  entry.name.equals(address.getName()) &
                  entry.deviceId.equals(address.getDeviceId()),
            ))
          .getSingleOrNull();
      final exists = await row != null;
      print(
        '[E2EE_TRACE] stage=session_contains event=success signal_address=${address.getName()}@${address.getDeviceId()} exists=$exists',
      );
      return exists;
    } catch (error, stackTrace) {
      print(
        '[E2EE_TRACE] stage=session_contains_error event=error signal_address=${address.getName()}@${address.getDeviceId()} error_type=${error.runtimeType} error_message=${error.toString()}',
      );
      print(stackTrace);
      rethrow;
    } finally {
      final durationMs = DateTime.now().difference(startedAt).inMilliseconds;
      print(
        '[E2EE_TRACE] stage=session_contains_complete event=complete signal_address=${address.getName()}@${address.getDeviceId()} duration_ms=$durationMs',
      );
    }
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
