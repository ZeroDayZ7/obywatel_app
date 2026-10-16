import 'dart:async';

import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

class DriftSignalProtocolStore implements SignalProtocolStore {
  DriftSignalProtocolStore(
    this.db, {
    IdentityKeyPair? identityKeyPair,
    int? localRegistrationId,
    AppLogger? logger,
  })  : _logger = logger ?? AppLogger(),
        _identityKeyPair = identityKeyPair ?? generateIdentityKeyPair(),
        _localRegistrationId =
            localRegistrationId ?? generateRegistrationId(false) {
    unawaited(_ensureLocalIdentityLoaded());
  }

  final AppDatabase db;
  final AppLogger _logger;
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
    try {
      await _ensureLocalIdentityLoaded();
      return _identityKeyPair;
    } catch (error, stackTrace) {
      _logger.e(
        '[E2EE_TRACE] stage=store_local_identity_read_error event=error error_type=${error.runtimeType} error_message=${error.toString()}',
        error: error,
        stackTrace: stackTrace,
        module: 'DriftSignalProtocolStore',
      );
      rethrow;
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
    if (identityKey == null) {
      _logger.w(
        '[E2EE_TRACE] stage=store_identity_save_skipped event=warning signal_address=${address.getName()}@${address.getDeviceId()} reason=identity_null',
        module: 'DriftSignalProtocolStore',
      );
      return false;
    }

    try {
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
    } catch (error, stackTrace) {
      _logger.e(
        '[E2EE_TRACE] stage=store_identity_save_error event=error signal_address=${address.getName()}@${address.getDeviceId()} error_type=${error.runtimeType} error_message=${error.toString()}',
        error: error,
        stackTrace: stackTrace,
        module: 'DriftSignalProtocolStore',
      );
      rethrow;
    }
  }

  @override
  Future<bool> isTrustedIdentity(
    SignalProtocolAddress address,
    IdentityKey? identityKey,
    Direction direction,
  ) async {
    if (identityKey == null) {
      _logger.w(
        '[E2EE_TRACE] stage=identity_trust_check event=warning signal_address=${address.getName()}@${address.getDeviceId()} direction=${direction.name} result=false reason=identity_null',
        module: 'DriftSignalProtocolStore',
      );
      return false;
    }

    try {
      final trusted = await getIdentity(address);
      return trusted == null ||
          const ListEquality<int>().equals(
            trusted.serialize(),
            identityKey.serialize(),
          );
    } catch (error, stackTrace) {
      _logger.e(
        '[E2EE_TRACE] stage=identity_trust_check_error event=error signal_address=${address.getName()}@${address.getDeviceId()} direction=${direction.name} error_type=${error.runtimeType} error_message=${error.toString()}',
        error: error,
        stackTrace: stackTrace,
        module: 'DriftSignalProtocolStore',
      );
      rethrow;
    }
  }

  @override
  Future<IdentityKey?> getIdentity(SignalProtocolAddress address) async {
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
        return null;
      }

      return IdentityKey.fromBytes(result.identityKey, 0);
    } catch (error, stackTrace) {
      _logger.e(
        '[E2EE_TRACE] stage=identity_read_error event=error signal_address=${address.getName()}@${address.getDeviceId()} error_type=${error.runtimeType} error_message=${error.toString()}',
        error: error,
        stackTrace: stackTrace,
        module: 'DriftSignalProtocolStore',
      );
      rethrow;
    }
  }

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async {
    try {
      final row = (db.select(db.signalPreKeys)
            ..where((entry) => entry.id.equals(preKeyId)))
          .getSingleOrNull();

      final record = await row;
      if (record == null) {
        throw InvalidKeyIdException('Missing pre-key: $preKeyId');
      }

      return PreKeyRecord.fromBuffer(record.record);
    } catch (error, stackTrace) {
      _logger.e(
        '[E2EE_TRACE] stage=prekey_load_error event=error pre_key_id=$preKeyId error_type=${error.runtimeType} error_message=${error.toString()}',
        error: error,
        stackTrace: stackTrace,
        module: 'DriftSignalProtocolStore',
      );
      rethrow;
    }
  }

  @override
  Future<void> storePreKey(int preKeyId, PreKeyRecord record) async {
    try {
      final serialized = record.serialize();
      await db.into(db.signalPreKeys).insertOnConflictUpdate(
        SignalPreKeysCompanion(
          id: Value(preKeyId),
          record: Value(serialized),
        ),
      );
    } catch (error, stackTrace) {
      _logger.e(
        '[E2EE_TRACE] stage=prekey_store_error event=error pre_key_id=$preKeyId error_type=${error.runtimeType} error_message=${error.toString()}',
        error: error,
        stackTrace: stackTrace,
        module: 'DriftSignalProtocolStore',
      );
      rethrow;
    }
  }

  @override
  Future<bool> containsPreKey(int preKeyId) async {
    try {
      final row = (db.select(db.signalPreKeys)
            ..where((entry) => entry.id.equals(preKeyId)))
          .getSingleOrNull();
      return await row != null;
    } catch (error, stackTrace) {
      _logger.e(
        '[E2EE_TRACE] stage=prekey_contains_error event=error pre_key_id=$preKeyId error_type=${error.runtimeType} error_message=${error.toString()}',
        error: error,
        stackTrace: stackTrace,
        module: 'DriftSignalProtocolStore',
      );
      rethrow;
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
        return SessionRecord();
      }

      return SessionRecord.fromSerialized(result.record);
    } catch (error, stackTrace) {
      _logger.e(
        '[E2EE_TRACE] stage=session_load_error event=error signal_address=${address.getName()}@${address.getDeviceId()} error_type=${error.runtimeType} error_message=${error.toString()}',
        error: error,
        stackTrace: stackTrace,
        module: 'DriftSignalProtocolStore',
      );
      rethrow;
    }
  }

  @override
  Future<List<int>> getSubDeviceSessions(String name) async {
    final rows = await (db.select(db.signalSessions)
          ..where((entry) => entry.name.equals(name) & entry.deviceId.isNotNull()))
        .get();

    return rows.map((row) => row.deviceId).toList();
  }

  @override
  Future<void> storeSession(
    SignalProtocolAddress address,
    SessionRecord record,
  ) async {
    try {
      final serialized = record.serialize();
      await db.into(db.signalSessions).insertOnConflictUpdate(
        SignalSessionsCompanion(
          name: Value(address.getName()),
          deviceId: Value(address.getDeviceId()),
          record: Value(serialized),
        ),
      );
    } catch (error, stackTrace) {
      _logger.e(
        '[E2EE_TRACE] stage=session_store_error event=error signal_address=${address.getName()}@${address.getDeviceId()} error_type=${error.runtimeType} error_message=${error.toString()}',
        error: error,
        stackTrace: stackTrace,
        module: 'DriftSignalProtocolStore',
      );
      rethrow;
    }
  }

  @override
  Future<bool> containsSession(SignalProtocolAddress address) async {
    try {
      final row = (db.select(db.signalSessions)
            ..where(
              (entry) =>
                  entry.name.equals(address.getName()) &
                  entry.deviceId.equals(address.getDeviceId()),
            ))
          .getSingleOrNull();
      return await row != null;
    } catch (error, stackTrace) {
      _logger.e(
        '[E2EE_TRACE] stage=session_contains_error event=error signal_address=${address.getName()}@${address.getDeviceId()} error_type=${error.runtimeType} error_message=${error.toString()}',
        error: error,
        stackTrace: stackTrace,
        module: 'DriftSignalProtocolStore',
      );
      rethrow;
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
