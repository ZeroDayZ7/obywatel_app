import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:obywatel_plus/core/crypto/drift_signal_protocol_store.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/communication/data/mappers/e2ee_crypto_mapper.dart'
    as e2ee_crypto_mapper;
import 'package:obywatel_plus/features/communication/domain/crypto/e2ee_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'e2ee_crypto_service.g.dart';

class EncryptionFailureException implements Exception {
  final String message;

  const EncryptionFailureException(this.message);

  @override
  String toString() => 'EncryptionFailureException: $message';
}

class SignalDeviceMappingException implements Exception {
  final String message;

  const SignalDeviceMappingException(this.message);

  @override
  String toString() => 'SignalDeviceMappingException: $message';
}

class SignalDeviceMappingConflictException
    extends SignalDeviceMappingException {
  const SignalDeviceMappingConflictException(super.message);
}

class SignalSessionNotFoundException implements Exception {
  final String message;

  const SignalSessionNotFoundException(this.message);

  @override
  String toString() => 'SignalSessionNotFoundException: $message';
}

class E2eeCryptoService {
  E2eeCryptoService(
    this._secureStorage,
    this._logger,
    this._apiClient,
    this._deviceInfoService,
    this._signalStore,
  );

  static PreKeyBundle fromPreKeyBundleJson(Map<String, dynamic> json) =>
      e2ee_crypto_mapper.fromPreKeyBundleJson(json);

  static SignalDeviceId resolveSignalDeviceId(
    String? rawDeviceId, {
    SignalDeviceId? fallback,
  }) =>
      e2ee_crypto_mapper.resolveSignalDeviceId(rawDeviceId, fallback: fallback);

  static String fingerprintIdentityKey(IdentityKey? identityKey) =>
      e2ee_crypto_mapper.fingerprintIdentityKey(identityKey);

  static String requireAppDeviceUuid(
    String? rawAppDeviceId, {
    String context = 'app_device_id',
  }) =>
      e2ee_crypto_mapper.requireAppDeviceUuid(rawAppDeviceId, context: context);

  final SecureStorageService _secureStorage;
  final AppLogger _logger;
  final ApiClient _apiClient;
  final DeviceInfoService _deviceInfoService;
  final DriftSignalProtocolStore _signalStore;

  static const String _sessionKeyPrefix = 'e2ee_session_key_';
  static const String _signalDeviceMappingStorageKey =
      'e2ee_signal_device_mapping';
  bool _deviceIdentityRegistered = false;
  Future<void>? _deviceIdentityRegistrationTask;
  Future<void>? _signalDeviceMappingWriteLock;

  static String _signalAddressName(SignalProtocolAddress address) =>
      '${address.getName()}@${address.getDeviceId()}';

  static Map<String, Map<String, int>> setSignalDeviceMapping({
    required String senderUserId,
    required String appDeviceId,
    required int signalDeviceId,
    Map<String, Map<String, int>>? existingMappings,
  }) {
    final normalizedUserId = senderUserId.trim();
    if (normalizedUserId.isEmpty) {
      throw const FormatException(
        'A Signal sender user id is required when setting a device mapping.',
      );
    }

    final normalizedAppDeviceId = requireAppDeviceUuid(
      appDeviceId,
      context: 'app_device_id',
    );
    final resolvedSignalDeviceId = resolveSignalDeviceId(
      signalDeviceId.toString(),
    );

    final normalizedMappings = <String, Map<String, int>>{
      for (final entry in (existingMappings ?? const {}).entries)
        entry.key: Map<String, int>.from(entry.value),
    };
    final userMappings = Map<String, int>.from(
      normalizedMappings[normalizedUserId] ?? const <String, int>{},
    );

    final existingSignalDeviceId = userMappings[normalizedAppDeviceId];
    if (existingSignalDeviceId != null &&
        existingSignalDeviceId != resolvedSignalDeviceId) {
      throw SignalDeviceMappingConflictException(
        'Conflicting Signal device mapping for appDeviceId=$normalizedAppDeviceId on user $normalizedUserId: $existingSignalDeviceId vs $resolvedSignalDeviceId.',
      );
    }

    userMappings[normalizedAppDeviceId] = resolvedSignalDeviceId;
    normalizedMappings[normalizedUserId] = userMappings;
    return normalizedMappings;
  }

  static int resolveInboundSignalDeviceId({
    required String senderUserId,
    required String senderDeviceId,
    required Map<String, Map<String, int>> mappedSignalDeviceIds,
  }) {
    final normalizedUserId = senderUserId.trim();
    final trimmedSenderDeviceId = senderDeviceId.trim();

    if (normalizedUserId.isEmpty) {
      throw const FormatException(
        'Inbound sender user id is missing; a valid Signal user id is required.',
      );
    }
    if (trimmedSenderDeviceId.isEmpty) {
      throw const FormatException(
        'Inbound senderDeviceId is empty; it must be the appDeviceId UUID for this message.',
      );
    }

    if (int.tryParse(trimmedSenderDeviceId) != null) {
      throw const FormatException(
        'Inbound senderDeviceId is numeric but the app contract uses appDeviceId UUID for message metadata. Numeric Signal device ids must come from a verified backend mapping, not implicit parsing.',
      );
    }

    if (!Uuid.isValidUUID(fromString: trimmedSenderDeviceId)) {
      throw const FormatException(
        'Inbound senderDeviceId is not a valid appDeviceId UUID. Signal device ids are not inferred from arbitrary message metadata.',
      );
    }

    final userMappings =
        mappedSignalDeviceIds[normalizedUserId] ?? const <String, int>{};
    final mappedDeviceId = userMappings[trimmedSenderDeviceId];
    if (mappedDeviceId == null) {
      throw SignalDeviceMappingException(
        'No explicit appDeviceId -> signalDeviceId mapping exists for user $normalizedUserId and appDeviceId $trimmedSenderDeviceId.',
      );
    }

    return resolveSignalDeviceId(mappedDeviceId.toString());
  }

  Future<Map<String, Map<String, int>>> _loadSignalDeviceMappings() async {
    final rawValue = await _secureStorage.read(
      key: _signalDeviceMappingStorageKey,
    );
    if (rawValue == null || rawValue.trim().isEmpty) {
      return const <String, Map<String, int>>{};
    }

    try {
      final decodedValue = jsonDecode(rawValue);
      if (decodedValue is! Map) {
        throw const FormatException(
          'Persisted Signal device mappings must be stored as a JSON object.',
        );
      }

      final source = Map<String, dynamic>.from(decodedValue);
      final resolved = <String, Map<String, int>>{};
      for (final entry in source.entries) {
        final userId = entry.key.trim();
        final userMappings = entry.value;
        if (userId.isEmpty || userMappings is! Map) {
          throw const FormatException(
            'Persisted Signal device mappings contain invalid user entries.',
          );
        }

        final explicitMappings = <String, int>{};
        for (final mappingEntry in Map<String, dynamic>.from(
          userMappings,
        ).entries) {
          final appDeviceId = mappingEntry.key.trim();
          final signalDeviceId = mappingEntry.value;
          if (appDeviceId.isEmpty ||
              !Uuid.isValidUUID(fromString: appDeviceId) ||
              signalDeviceId == null) {
            throw const FormatException(
              'Persisted Signal device mappings contain invalid app-device entries.',
            );
          }

          final parsedDeviceId = int.tryParse(signalDeviceId.toString());
          if (parsedDeviceId == null || parsedDeviceId <= 0) {
            throw const FormatException(
              'Persisted Signal device mappings contain non-positive Signal device ids.',
            );
          }

          explicitMappings[appDeviceId] = parsedDeviceId;
        }

        resolved[userId] = explicitMappings;
      }
      return resolved;
    } catch (error) {
      throw FormatException(
        'Stored Signal device mappings are corrupt or invalid: ${error.toString()}',
      );
    }
  }

  Future<void> _persistSignalDeviceMappingWithLock({
    required String senderUserId,
    required String appDeviceId,
    required int signalDeviceId,
  }) async {
    final persistedMappings = await _loadSignalDeviceMappings();
    final nextMappings = setSignalDeviceMapping(
      senderUserId: senderUserId,
      appDeviceId: appDeviceId,
      signalDeviceId: signalDeviceId,
      existingMappings: persistedMappings,
    );
    await _secureStorage.write(
      key: _signalDeviceMappingStorageKey,
      value: jsonEncode(nextMappings),
    );
  }

  Future<void> persistSignalDeviceMapping({
    required String senderUserId,
    required String appDeviceId,
    required int signalDeviceId,
  }) async {
    if (_signalDeviceMappingWriteLock != null) {
      await _signalDeviceMappingWriteLock;
      return;
    }

    _signalDeviceMappingWriteLock = _persistSignalDeviceMappingWithLock(
      senderUserId: senderUserId,
      appDeviceId: appDeviceId,
      signalDeviceId: signalDeviceId,
    );
    try {
      await _signalDeviceMappingWriteLock;
    } finally {
      _signalDeviceMappingWriteLock = null;
    }
  }

  Future<PreKeyBundle> fetchRemotePreKeyBundle(
    String remoteUserId, {
    String? operationId,
  }) async {
    final effectiveOperationId = operationId ?? const Uuid().v4();

    try {
      final headers = {'X-Operation-Id': effectiveOperationId};
      final response = await _apiClient.get(
        '/crypto/keys/prekeys/$remoteUserId',
        headers: headers,
      );
      final payload = response.data;

      if (payload is! Map) {
        throw const FormatException('Invalid remote pre-key bundle payload');
      }

      final map = Map<String, dynamic>.from(payload);
      return fromPreKeyBundleJson(map);
    } catch (error, stackTrace) {
      _logger.e(
        '[E2EE_TRACE] operation_id=$effectiveOperationId stage=prekey_bundle_fetch_error event=error remote_user_id=$remoteUserId error_type=${error.runtimeType} error_message=${error.toString()}',
        error: error,
        stackTrace: stackTrace,
        module: 'E2eeCrypto',
      );
      rethrow;
    }
  }

  Future<SignalProtocolAddress> initializeSessionForPeer(
    String remoteUserId, {
    required PreKeyBundle remoteBundle,
    int? deviceId,
    String? operationId,
  }) async {
    final effectiveOperationId = operationId ?? const Uuid().v4();
    final resolvedDeviceId = deviceId ?? remoteBundle.getDeviceId();
    if (resolvedDeviceId <= 0) {
      throw const FormatException(
        'Signal session device id is required and cannot be zero',
      );
    }
    final address = SignalProtocolAddress(remoteUserId, resolvedDeviceId);
    final bundleIdentity = remoteBundle.getIdentityKey();

    try {
      final builder = SessionBuilder.fromSignalStore(_signalStore, address);
      await builder.processPreKeyBundle(remoteBundle);
      await _signalStore.saveIdentity(address, bundleIdentity);
      return address;
    } catch (error, stackTrace) {
      _logger.e(
        '[E2EE_TRACE] operation_id=$effectiveOperationId stage=session_initialize_error event=error remote_user_id=$remoteUserId signal_address=${_signalAddressName(address)} error_type=${error.runtimeType} error_message=${error.toString()}',
        error: error,
        stackTrace: stackTrace,
        module: 'E2eeCrypto',
      );
      rethrow;
    }
  }

  Future<void> ensureSessionForPeer(
    String remoteUserId, {
    int? deviceId,
    String? operationId,
  }) async {
    final effectiveOperationId = _resolveOperationId(operationId);
    final explicitAddress = deviceId != null && deviceId > 0
        ? SignalProtocolAddress(remoteUserId, deviceId)
        : null;

    if (explicitAddress != null) {
      final sessionExists = await _signalStore.containsSession(explicitAddress);
      if (sessionExists) {
        return;
      }
    }

    try {
      await registerDeviceIdentityWithOperation(effectiveOperationId);
      final remoteBundle = await fetchRemotePreKeyBundle(
        remoteUserId,
        operationId: effectiveOperationId,
      );
      final bundleSignalDeviceId = remoteBundle.getDeviceId();
      final bundleAddress = SignalProtocolAddress(
        remoteUserId,
        bundleSignalDeviceId,
      );
      final hasSessionForBundle = await _signalStore.containsSession(
        bundleAddress,
      );
      if (hasSessionForBundle) {
        return;
      }

      await initializeSessionForPeer(
        remoteUserId,
        remoteBundle: remoteBundle,
        deviceId: bundleSignalDeviceId,
        operationId: effectiveOperationId,
      );
    } catch (error, stackTrace) {
      final fallbackAddress =
          explicitAddress ?? const SignalProtocolAddress('', 0);
      _logger.e(
        '[E2EE_TRACE] operation_id=$effectiveOperationId stage=session_init_error event=error remote_user_id=$remoteUserId signal_address=${_signalAddressName(fallbackAddress)} error_type=${error.runtimeType} error_message=${error.toString()}',
        error: error,
        stackTrace: stackTrace,
        module: 'E2eeCrypto',
      );
      rethrow;
    }
  }

  String _resolveOperationId(String? operationId) {
    final value = operationId?.trim();
    if (value != null && value.isNotEmpty) {
      return value;
    }
    return const Uuid().v4();
  }

  Future<bool> _hasPersistedDeviceIdentityMaterial() async {
    final hasSignedPreKey = await _signalStore.containsSignedPreKey(1);
    final preKeyChecks = await Future.wait(
      List<int>.generate(
        10,
        (index) => index + 1,
      ).map((preKeyId) => _signalStore.containsPreKey(preKeyId)),
    );
    final hasOneTimePreKeys = preKeyChecks.every((exists) => exists);
    return hasSignedPreKey && hasOneTimePreKeys;
  }

  Future<LocalDeviceKeyBundle> _ensureLocalDeviceIdentityBundle() async {
    final deviceId = await _deviceInfoService.getOrCreateDeviceId();
    final registrationId = await _signalStore.getLocalRegistrationId();
    final identityKeyPair = await _signalStore.getIdentityKeyPair();
    final hasPersistedState = await _hasPersistedDeviceIdentityMaterial();

    if (hasPersistedState) {
      final signedPreKey = await _signalStore.loadSignedPreKey(1);
      final oneTimePreKeys = await Future.wait(
        List<int>.generate(10, (index) => index + 1).map((preKeyId) async {
          final record = await _signalStore.loadPreKey(preKeyId);
          return OneTimePreKeyRegistration(
            keyId: preKeyId,
            publicKey: base64Encode(record.getKeyPair().publicKey.serialize()),
          );
        }),
      );

      return LocalDeviceKeyBundle(
        deviceId: deviceId,
        registrationId: registrationId,
        publicKey: base64Encode(identityKeyPair.getPublicKey().serialize()),
        privateKey: base64Encode(identityKeyPair.getPrivateKey().serialize()),
        signedPreKey: base64Encode(
          signedPreKey.getKeyPair().publicKey.serialize(),
        ),
        signedPreKeySignature: base64Encode(signedPreKey.signature),
        signedPreKeyId: signedPreKey.id,
        oneTimePreKeys: oneTimePreKeys,
      );
    }

    final signedPreKey = generateSignedPreKey(identityKeyPair, 1);
    await _signalStore.storeSignedPreKey(signedPreKey.id, signedPreKey);

    final oneTimePreKeys = generatePreKeys(1, 10);
    for (final record in oneTimePreKeys) {
      await _signalStore.storePreKey(record.id, record);
    }
    final oneTimePreKeyRegistrations = oneTimePreKeys
        .map(
          (record) => OneTimePreKeyRegistration(
            keyId: record.id,
            publicKey: base64Encode(record.getKeyPair().publicKey.serialize()),
          ),
        )
        .toList();

    return LocalDeviceKeyBundle(
      deviceId: deviceId,
      registrationId: registrationId,
      publicKey: base64Encode(identityKeyPair.getPublicKey().serialize()),
      privateKey: base64Encode(identityKeyPair.getPrivateKey().serialize()),
      signedPreKey: base64Encode(
        signedPreKey.getKeyPair().publicKey.serialize(),
      ),
      signedPreKeySignature: base64Encode(signedPreKey.signature),
      signedPreKeyId: signedPreKey.id,
      oneTimePreKeys: oneTimePreKeyRegistrations,
    );
  }

  Future<DeviceKeyBundle> ensureDeviceIdentityBundle() async {
    final localBundle = await _ensureLocalDeviceIdentityBundle();
    return localBundle.toRegistrationBundle();
  }

  Future<void> registerDeviceIdentity() async {
    await registerDeviceIdentityWithOperation(null);
  }

  Future<void> registerDeviceIdentityWithOperation(String? operationId) async {
    final effectiveOperationId = _resolveOperationId(operationId);
    if (_deviceIdentityRegistered) {
      return;
    }
    if (_deviceIdentityRegistrationTask != null) {
      await _deviceIdentityRegistrationTask;
      return;
    }

    _deviceIdentityRegistrationTask = () async {
      try {
        final persistedMarker = await _secureStorage.read(
          key: 'e2ee_device_registration_marker',
        );
        final localBundle = await _ensureLocalDeviceIdentityBundle();
        final bundle = localBundle.toRegistrationBundle();
        final marker = {
          'deviceId': bundle.deviceId,
          'registrationId': bundle.registrationId,
          'publicKeyFingerprint': sha256
              .convert(base64Decode(bundle.publicKey))
              .toString(),
          'signedPreKeyId': bundle.signedPreKeyId,
        }.toString();

        if (persistedMarker != null) {
          if (persistedMarker == marker) {
            _deviceIdentityRegistered = true;
            return;
          }

          throw StateError(
            'Persisted device registration marker exists but does not match the current local Signal identity material. Explicit re-registration is required; no silent regeneration or trust reset is allowed.',
          );
        }

        final payload = bundle.toRegistrationPayload();
        final transportKeys = <String>{
          'privateKey',
          'privateKeyBase64',
          'private_key',
          'devicePrivateKey',
          'device_private_key',
        };
        final hasPrivateMaterial = transportKeys.any(payload.containsKey);
        if (hasPrivateMaterial) {
          throw StateError(
            'Private E2EE keys must never be sent to the backend',
          );
        }

        final headers = {'X-Operation-Id': effectiveOperationId};
        await _apiClient.post(
          '/crypto/keys/device',
          data: payload,
          headers: headers,
        );
        await _secureStorage.write(
          key: 'e2ee_device_registration_marker',
          value: marker,
        );
        _deviceIdentityRegistered = true;
      } catch (error, stackTrace) {
        _logger.e(
          '[E2EE_TRACE] operation_id=$effectiveOperationId stage=device_identity_registration_error event=error error_type=${error.runtimeType} error_message=${error.toString()}',
          error: error,
          stackTrace: stackTrace,
          module: 'E2eeCrypto',
        );
        rethrow;
      } finally {
        _deviceIdentityRegistrationTask = null;
      }
    }();

    await _deviceIdentityRegistrationTask;
  }

  Future<void> storeSessionKey(String conversationId, String base64Key) async {
    await _secureStorage.write(
      key: '$_sessionKeyPrefix$conversationId',
      value: base64Key,
    );
  }

  Future<String?> getSessionKey(String conversationId) async {
    return _secureStorage.read(key: '$_sessionKeyPrefix$conversationId');
  }

  Future<SignalProtocolAddress> resolveOrCreateSessionAddress(
    String recipientUserId,
    int? recipientDeviceId,
    String operationId,
  ) async {
    var resolvedDeviceId = recipientDeviceId;
    if (resolvedDeviceId == null || resolvedDeviceId <= 0) {
      final knownSessionDeviceIds = await _signalStore.getSubDeviceSessions(
        recipientUserId,
      );
      resolvedDeviceId = knownSessionDeviceIds.firstWhere(
        (deviceId) => deviceId > 0,
        orElse: () => 0,
      );

      if (resolvedDeviceId <= 0) {
        final remoteBundle = await fetchRemotePreKeyBundle(
          recipientUserId,
          operationId: operationId,
        );
        resolvedDeviceId = remoteBundle.getDeviceId();
        final address = SignalProtocolAddress(
          recipientUserId,
          resolvedDeviceId,
        );

        if (!await _signalStore.containsSession(address)) {
          await initializeSessionForPeer(
            recipientUserId,
            remoteBundle: remoteBundle,
            deviceId: resolvedDeviceId,
            operationId: operationId,
          );
        }
      }
    }

    if (resolvedDeviceId <= 0) {
      throw const FormatException('Signal recipient device id is required');
    }

    final address = SignalProtocolAddress(recipientUserId, resolvedDeviceId);
    if (!await _signalStore.containsSession(address)) {
      await registerDeviceIdentityWithOperation(operationId);
      final remoteBundle = await fetchRemotePreKeyBundle(
        recipientUserId,
        operationId: operationId,
      );
      final bundleSignalDeviceId = remoteBundle.getDeviceId();
      final bundleAddress = SignalProtocolAddress(
        recipientUserId,
        bundleSignalDeviceId,
      );

      if (!await _signalStore.containsSession(bundleAddress)) {
        await initializeSessionForPeer(
          recipientUserId,
          remoteBundle: remoteBundle,
          deviceId: bundleSignalDeviceId,
          operationId: operationId,
        );
      }

      return bundleAddress;
    }

    return address;
  }

  Future<SessionCipher> getOrCreateSessionCipher(
    String recipientUserId,
    int? recipientDeviceId,
    String operationId,
  ) async {
    final address = await resolveOrCreateSessionAddress(
      recipientUserId,
      recipientDeviceId,
      operationId,
    );
    return SessionCipher.fromStore(_signalStore, address);
  }

  Future<SignalCiphertextEnvelope> encryptOutboundMessage(
    String recipientUserId,
    String plaintext, {
    int? recipientDeviceId,
    String? senderDeviceId,
    String? operationId,
  }) async {
    final effectiveOperationId = _resolveOperationId(operationId);
    var address = const SignalProtocolAddress('', 0);

    try {
      address = await resolveOrCreateSessionAddress(
        recipientUserId,
        recipientDeviceId,
        effectiveOperationId,
      );
      final sessionCipher = SessionCipher.fromStore(_signalStore, address);

      final cipherText = await sessionCipher.encrypt(
        Uint8List.fromList(utf8.encode(plaintext)),
      );

      final envelope = SignalCiphertextEnvelope(
        type: cipherText.getType(),
        ciphertext: base64Encode(cipherText.serialize()),
        senderDeviceId:
            senderDeviceId ?? await _deviceInfoService.getOrCreateDeviceId(),
        recipientUserId: recipientUserId,
        recipientDeviceId: address.getDeviceId().toString(),
      );
      return envelope;
    } catch (e, st) {
      _logger.e(
        '[E2EE_TRACE] operation_id=$effectiveOperationId stage=encrypt_error event=error recipient_user_id=$recipientUserId signal_address=${_signalAddressName(address)} error_type=${e.runtimeType} error_message=${e.toString()}',
        error: e,
        stackTrace: st,
        module: 'E2eeCrypto',
      );
      throw EncryptionFailureException(
        'Nie można zaszyfrować wiadomości dla użytkownika $recipientUserId',
      );
    }
  }

  Future<String> decryptInboundMessage({
    required String senderUserId,
    required String senderDeviceId,
    required String ciphertextBase64,
    required int type,
    String? operationId,
  }) async {
    final effectiveOperationId = operationId ?? const Uuid().v4();
    final signalDeviceId = resolveInboundSignalDeviceId(
      senderUserId: senderUserId,
      senderDeviceId: senderDeviceId,
      mappedSignalDeviceIds: await _loadSignalDeviceMappings(),
    );
    final address = SignalProtocolAddress(senderUserId, signalDeviceId);

    if (!await _signalStore.containsSession(address)) {
      throw SignalSessionNotFoundException(
        'No local Signal session exists for sender $senderUserId on device $signalDeviceId. Refusing to use a different session as fallback.',
      );
    }

    try {
      final ciphertextBytes = base64Decode(ciphertextBase64);
      final sessionCipher = SessionCipher.fromStore(_signalStore, address);

      final Uint8List plaintext;
      if (type == CiphertextMessage.prekeyType) {
        plaintext = await sessionCipher.decrypt(
          PreKeySignalMessage(ciphertextBytes),
        );
      } else {
        plaintext = await sessionCipher.decryptFromSignal(
          SignalMessage.fromSerialized(ciphertextBytes),
        );
      }

      return utf8.decode(plaintext);
    } catch (e, st) {
      _logger.w(
        '[E2EE_TRACE] operation_id=$effectiveOperationId stage=decrypt_session_failed event=warning sender_user_id=$senderUserId signal_device_id=$signalDeviceId signal_type=$type error_type=${e.runtimeType}',
        error: e,
        stackTrace: st,
        module: 'E2eeCrypto',
      );
      throw EncryptionFailureException(
        'Nie można odszyfrować wiadomości od użytkownika $senderUserId dla urządzenia $signalDeviceId. Nie wolno przełączać się na inną sesję Signal.',
      );
    }
  }

  Future<EncryptedData> encryptMessage(
    String remoteUserId,
    String plaintext, {
    String? operationId,
  }) async {
    try {
      final envelope = await encryptOutboundMessage(
        remoteUserId,
        plaintext,
        operationId: operationId,
      );
      return EncryptedData(
        ciphertextBase64: envelope.ciphertext,
        nonceBase64: '',
        type: envelope.type,
      );
    } catch (e, st) {
      if (e is EncryptionFailureException) {
        rethrow;
      }

      _logger.e(
        'Błąd szyfrowania wiadomości Signal',
        error: e,
        stackTrace: st,
        module: 'E2eeCrypto',
      );
      throw EncryptionFailureException(
        'Nie można zaszyfrować wiadomości dla użytkownika $remoteUserId',
      );
    }
  }
}

@riverpod
E2eeCryptoService e2eeCryptoService(Ref ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final logger = ref.watch(appLoggerProvider);
  final apiClient = ref.watch(apiClientProvider);
  final deviceInfoService = ref.watch(deviceInfoServiceProvider);
  final db = ref.watch(appDatabaseProvider);
  final signalStore = DriftSignalProtocolStore(db, logger: logger);

  return E2eeCryptoService(
    secureStorage,
    logger,
    apiClient,
    deviceInfoService,
    signalStore,
  );
}
