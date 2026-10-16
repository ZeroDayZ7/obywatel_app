import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';
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
  bool _deviceIdentityRegistered = false;
  Future<void>? _deviceIdentityRegistrationTask;

  static String _signalAddressName(SignalProtocolAddress address) =>
      '${address.getName()}@${address.getDeviceId()}';

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
        '[E2EE_TRACE] operation_id=$effectiveOperationId stage=prekey_bundle_fetch_error event=error remote_user_id=$remoteUserId error_type=${error.runtimeType}',
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
        '[E2EE_TRACE] operation_id=$effectiveOperationId stage=session_initialize_error event=error remote_user_id=$remoteUserId signal_address=${_signalAddressName(address)} error_type=${error.runtimeType}',
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
        '[E2EE_TRACE] operation_id=$effectiveOperationId stage=session_init_error event=error remote_user_id=$remoteUserId signal_address=${_signalAddressName(fallbackAddress)} error_type=${error.runtimeType}',
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
    final registrationId = await _signalStore.getLocalRegistrationId();
    final identityKeyPair = await _signalStore.getIdentityKeyPair();
    final hasRegistrationId = registrationId > 0;
    final hasIdentityKey = identityKeyPair
        .getPublicKey()
        .serialize()
        .isNotEmpty;
    final hasSignedPreKey = await _signalStore.containsSignedPreKey(1);
    final preKeyChecks = await Future.wait(
      List<int>.generate(
        10,
        (index) => index + 1,
      ).map((preKeyId) => _signalStore.containsPreKey(preKeyId)),
    );
    final hasOneTimePreKeys = preKeyChecks.any((exists) => exists);
    return hasRegistrationId &&
        hasIdentityKey &&
        hasSignedPreKey &&
        hasOneTimePreKeys;
  }

  Future<LocalDeviceIdentityMaterial> ensureDeviceIdentityBundle() async {
    final deviceId = await _deviceInfoService.getOrCreateDeviceId();
    final registrationId = await _signalStore.getLocalRegistrationId();
    final identityKeyPair = await _signalStore.getIdentityKeyPair();
    final hasPersistedState = await _hasPersistedDeviceIdentityMaterial();

    if (hasPersistedState) {
      final signedPreKey = await _signalStore.loadSignedPreKey(1);
      final keyIds = await Future.wait(
        List<int>.generate(10, (index) => index + 1).map((preKeyId) async {
          final exists = await _signalStore.containsPreKey(preKeyId);
          return exists ? preKeyId : null;
        }),
      );
      final availablePreKeyIds = keyIds.whereType<int>().toList()..sort();
      final oneTimePreKeys = await Future.wait(
        availablePreKeyIds.map((preKeyId) async {
          final record = await _signalStore.loadPreKey(preKeyId);
          return OneTimePreKeyRegistration(
            keyId: preKeyId,
            publicKey: base64Encode(record.getKeyPair().publicKey.serialize()),
          );
        }),
      );

      return LocalDeviceIdentityMaterial(
        deviceId: deviceId,
        registrationId: registrationId,
        identityPublicKey: base64Encode(
          identityKeyPair.getPublicKey().serialize(),
        ),
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

    return LocalDeviceIdentityMaterial(
      deviceId: deviceId,
      registrationId: registrationId,
      identityPublicKey: base64Encode(
        identityKeyPair.getPublicKey().serialize(),
      ),
      privateKey: base64Encode(identityKeyPair.getPrivateKey().serialize()),
      signedPreKey: base64Encode(
        signedPreKey.getKeyPair().publicKey.serialize(),
      ),
      signedPreKeySignature: base64Encode(signedPreKey.signature),
      signedPreKeyId: signedPreKey.id,
      oneTimePreKeys: oneTimePreKeyRegistrations,
    );
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
        final localMaterial = await ensureDeviceIdentityBundle();
        final marker = DeviceRegistrationMarker.fromLocalMaterial(
          localMaterial,
        );
        final persistedMarkerValue = await _secureStorage.read(
          key: 'e2ee_device_registration_marker',
        );

        if (persistedMarkerValue != null) {
          final persistedMarker = DeviceRegistrationMarker.fromStored(
            persistedMarkerValue,
          );
          if (persistedMarker.matches(localMaterial)) {
            _deviceIdentityRegistered = true;
            return;
          }

          throw StateError(
            'Persisted E2EE registration marker does not match the current local Signal identity material and no silent trust reset is allowed.',
          );
        }

        final payload = localMaterial.toRegistrationRequest().toJson();
        final headers = {'X-Operation-Id': effectiveOperationId};
        await _apiClient.post(
          '/crypto/keys/device',
          data: payload,
          headers: headers,
        );
        await _secureStorage.write(
          key: 'e2ee_device_registration_marker',
          value: marker.toPersistedValue(),
        );
        _deviceIdentityRegistered = true;
      } catch (error, stackTrace) {
        _logger.e(
          '[E2EE_TRACE] operation_id=$effectiveOperationId stage=device_identity_registration_error event=error error_type=${error.runtimeType}',
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
        '[E2EE_TRACE] operation_id=$effectiveOperationId stage=encrypt_error event=error recipient_user_id=$recipientUserId signal_address=${_signalAddressName(address)} error_type=${e.runtimeType}',
        error: e,
        stackTrace: st,
        module: 'E2eeCrypto',
      );
      throw EncryptionFailureException(
        'Nie można zaszyfrować wiadomości dla użytkownika $recipientUserId',
      );
    }
  }

  Future<Set<int>> resolveInboundSignalDeviceCandidates({
    required String senderUserId,
    required String senderDeviceId,
    String? operationId,
  }) async {
    final effectiveOperationId = operationId ?? const Uuid().v4();
    final trimmedSenderDeviceId = senderDeviceId.trim();
    final candidateDeviceIds = <int>{};

    final explicitDeviceId = int.tryParse(trimmedSenderDeviceId);
    if (explicitDeviceId != null && explicitDeviceId > 0) {
      candidateDeviceIds.add(explicitDeviceId);
    }

    final knownDeviceIds = await _signalStore.getSubDeviceSessions(
      senderUserId,
    );
    for (final knownDeviceId in knownDeviceIds) {
      if (knownDeviceId > 0) {
        candidateDeviceIds.add(knownDeviceId);
      }
    }

    if (candidateDeviceIds.isNotEmpty) {
      return candidateDeviceIds;
    }

    if (!Uuid.isValidUUID(fromString: trimmedSenderDeviceId)) {
      return candidateDeviceIds;
    }

    try {
      final remoteBundle = await fetchRemotePreKeyBundle(
        senderUserId,
        operationId: effectiveOperationId,
      );
      final resolvedDeviceId = remoteBundle.getDeviceId();
      if (resolvedDeviceId > 0) {
        candidateDeviceIds.add(resolvedDeviceId);
      }
    } catch (error, stackTrace) {
      _logger.w(
        '[E2EE_TRACE] operation_id=$effectiveOperationId stage=decrypt_resolve_uuid_bundle event=warning sender_user_id=$senderUserId sender_app_device_id=$trimmedSenderDeviceId error_type=${error.runtimeType} error_message=${error.toString()}',
        error: error,
        stackTrace: stackTrace,
        module: 'E2eeCrypto',
      );
    }

    _logger.w(
      '[E2EE_TRACE] operation_id=$effectiveOperationId stage=decrypt_mapping_failed event=warning sender_user_id=$senderUserId signal_device_id_candidate=$trimmedSenderDeviceId',
      module: 'E2eeCrypto',
    );
    throw FormatException(
      'No valid Signal device mapping was found for $senderUserId; device ids must be numeric or must already exist in the local session store.',
    );
  }

  Future<String> decryptInboundMessage({
    required String senderUserId,
    required String senderDeviceId,
    required String ciphertextBase64,
    required int type,
    String? operationId,
  }) async {
    final effectiveOperationId = operationId ?? const Uuid().v4();
    final trimmedSenderDeviceId = senderDeviceId.trim();
    final candidateDeviceIds = await resolveInboundSignalDeviceCandidates(
      senderUserId: senderUserId,
      senderDeviceId: senderDeviceId,
      operationId: effectiveOperationId,
    );

    if (candidateDeviceIds.isEmpty) {
      final senderAppDeviceId = requireAppDeviceUuid(
        trimmedSenderDeviceId,
        context: 'sender_device_id',
      );
      if (Uuid.isValidUUID(fromString: senderAppDeviceId)) {
        throw FormatException(
          'Inbound sender app UUID was not resolvable to a numeric Signal device id. The app must use the remote pre-key bundle or saved session mapping before decrypting.',
        );
      }
      throw const FormatException(
        'No valid numeric Signal device id was found for this inbound message; local session data is missing or stale',
      );
    }

    Object? lastError;
    for (final candidateDeviceId in candidateDeviceIds) {
      final address = SignalProtocolAddress(senderUserId, candidateDeviceId);
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

        final decoded = utf8.decode(plaintext);
        return decoded;
      } catch (e, st) {
        lastError = e;
        _logger.w(
          '[E2EE_TRACE] operation_id=$effectiveOperationId stage=decrypt_candidate_failed event=warning sender_user_id=$senderUserId signal_address=${_signalAddressName(address)} signal_device_id=$candidateDeviceId signal_type=$type error_type=${e.runtimeType}',
          error: e,
          stackTrace: st,
          module: 'E2eeCrypto',
        );
      }
    }

    final lastErrorType = lastError?.runtimeType.toString() ?? 'unknown';
    throw EncryptionFailureException(
      'Nie można odszyfrować wiadomości od użytkownika $senderUserId. Brak poprawnego numeru Signal device id dla lokalnej sesji. Ostatni błąd: $lastErrorType',
    );
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
