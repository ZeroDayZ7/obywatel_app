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
  }) => e2ee_crypto_mapper.resolveSignalDeviceId(rawDeviceId, fallback: fallback);

  static String fingerprintIdentityKey(IdentityKey? identityKey) =>
      e2ee_crypto_mapper.fingerprintIdentityKey(identityKey);

  static String requireAppDeviceUuid(
    String? rawAppDeviceId, {
    String context = 'app_device_id',
  }) => e2ee_crypto_mapper.requireAppDeviceUuid(
    rawAppDeviceId,
    context: context,
  );

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
    _logger.i(
      '[E2EE_TRACE] operation_id=$effectiveOperationId stage=prekey_bundle_fetch_start event=start remote_user_id=$remoteUserId',
      module: 'E2eeCrypto',
    );

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
      final bundle = fromPreKeyBundleJson(map);
      _logger.i(
        '[E2EE_TRACE] operation_id=$effectiveOperationId stage=prekey_bundle_fetch_success event=success remote_user_id=$remoteUserId bundle_device_id=${bundle.getDeviceId()} bundle_identity_fingerprint=${fingerprintIdentityKey(bundle.getIdentityKey())} bundle_has_prekey=${bundle.getPreKeyId() != null}',
        module: 'E2eeCrypto',
      );
      return bundle;
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
    final existingIdentity = await _signalStore.getIdentity(address);
    final existingFingerprint = fingerprintIdentityKey(existingIdentity);
    final bundleFingerprint = fingerprintIdentityKey(bundleIdentity);

    _logger.i(
      '[E2EE_TRACE] operation_id=$effectiveOperationId stage=session_initialize_start event=start remote_user_id=$remoteUserId signal_address=${_signalAddressName(address)} bundle_identity_fingerprint=$bundleFingerprint known_identity_fingerprint=$existingFingerprint',
      module: 'E2eeCrypto',
    );

    final startedAt = DateTime.now();
    try {
      final builder = SessionBuilder.fromSignalStore(_signalStore, address);
      await builder.processPreKeyBundle(remoteBundle);
      _logger.i(
        '[E2EE_TRACE] operation_id=$effectiveOperationId stage=session_builder_process event=success remote_user_id=$remoteUserId signal_address=${_signalAddressName(address)} duration_ms=${DateTime.now().difference(startedAt).inMilliseconds}',
        module: 'E2eeCrypto',
      );
      await _signalStore.saveIdentity(address, bundleIdentity);
      _logger.i(
        '[E2EE_TRACE] operation_id=$effectiveOperationId stage=signal_store_save_identity event=success remote_user_id=$remoteUserId signal_address=${_signalAddressName(address)} identity_fingerprint=$bundleFingerprint',
        module: 'E2eeCrypto',
      );
      final refreshedIdentity = await _signalStore.getIdentity(address);
      _logger.i(
        '[E2EE_TRACE] operation_id=$effectiveOperationId stage=session_identity_verify event=success remote_user_id=$remoteUserId signal_address=${_signalAddressName(address)} stored_identity_fingerprint=${fingerprintIdentityKey(refreshedIdentity)}',
        module: 'E2eeCrypto',
      );
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
      _logger.i(
        '[E2EE_TRACE] operation_id=$effectiveOperationId stage=session_check_start event=start remote_user_id=$remoteUserId signal_address=${_signalAddressName(explicitAddress)} session_exists=$sessionExists',
        module: 'E2eeCrypto',
      );
      if (sessionExists) {
        _logger.i(
          '[E2EE_TRACE] operation_id=$effectiveOperationId stage=session_reuse event=success remote_user_id=$remoteUserId signal_address=${_signalAddressName(explicitAddress)}',
          module: 'E2eeCrypto',
        );
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
      _logger.i(
        '[E2EE_TRACE] operation_id=$effectiveOperationId stage=prekey_bundle_decision event=success remote_user_id=$remoteUserId bundle_device_id=$bundleSignalDeviceId bundle_identity_fingerprint=${fingerprintIdentityKey(remoteBundle.getIdentityKey())}',
        module: 'E2eeCrypto',
      );
      final hasSessionForBundle = await _signalStore.containsSession(
        bundleAddress,
      );
      if (hasSessionForBundle) {
        _logger.i(
          '[E2EE_TRACE] operation_id=$effectiveOperationId stage=session_reuse_bundle event=success remote_user_id=$remoteUserId signal_address=${_signalAddressName(bundleAddress)}',
          module: 'E2eeCrypto',
        );
        return;
      }

      final activeAddress = await initializeSessionForPeer(
        remoteUserId,
        remoteBundle: remoteBundle,
        deviceId: bundleSignalDeviceId,
        operationId: effectiveOperationId,
      );
      _logger.i(
        '[E2EE_TRACE] operation_id=$effectiveOperationId stage=session_init_complete event=success remote_user_id=$remoteUserId signal_address=${_signalAddressName(activeAddress)} bundle_address=${_signalAddressName(bundleAddress)}',
        module: 'E2eeCrypto',
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

  Future<DeviceKeyBundle> ensureDeviceIdentityBundle() async {
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

      return DeviceKeyBundle(
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

    return DeviceKeyBundle(
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

  Future<void> registerDeviceIdentity() async {
    await registerDeviceIdentityWithOperation(null);
  }

  Future<void> registerDeviceIdentityWithOperation(String? operationId) async {
    final effectiveOperationId = _resolveOperationId(operationId);
    _logger.i(
      '[E2EE_TRACE] operation_id=$effectiveOperationId stage=device_identity_registration_start event=start',
      module: 'E2eeCrypto',
    );
    if (_deviceIdentityRegistered) {
      _logger.i(
        '[E2EE-FLOW-2.1] device identity already registered; skipping',
        module: 'E2eeCrypto',
      );
      return;
    }
    if (_deviceIdentityRegistrationTask != null) {
      _logger.i(
        '[E2EE-FLOW-2.2] device identity registration already in progress; waiting',
        module: 'E2eeCrypto',
      );
      await _deviceIdentityRegistrationTask;
      return;
    }

    _deviceIdentityRegistrationTask = () async {
      try {
        final persistedMarker = await _secureStorage.read(
          key: 'e2ee_device_registration_marker',
        );
        final bundle = await ensureDeviceIdentityBundle();
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
            _logger.i(
              '[E2EE-FLOW-2.3] device identity already published for this installation; skipping duplicate registration',
              module: 'E2eeCrypto',
            );
            return;
          }

          throw StateError(
            'Persisted device registration marker exists but does not match the current local Signal identity material. Explicit re-registration is required; no silent regeneration or trust reset is allowed.',
          );
        }

        final payload = {
          'deviceId': bundle.deviceId,
          'registrationId': bundle.registrationId,
          'identityPublicKey': bundle.publicKey,
          'publicKey': bundle.publicKey,
          'signedPreKey': bundle.signedPreKey,
          'signedPreKeySig': bundle.signedPreKeySignature,
          'signedPreKeyId': bundle.signedPreKeyId,
          'oneTimePreKeys': bundle.oneTimePreKeys
              .map((preKey) => preKey.toJson())
              .toList(),
        };

        if (payload.containsKey('private_key') ||
            payload.containsKey('device_private_key') ||
            payload.containsValue(bundle.privateKey)) {
          throw StateError(
            'Private E2EE keys must never be sent to the backend',
          );
        }

        final headers = {'X-Operation-Id': effectiveOperationId};
        _logger.i(
          '[E2EE_TRACE] operation_id=$effectiveOperationId stage=device_identity_registration_request event=start payload_fields=${payload.keys.toList()} registrationId=${payload['registrationId']} deviceId=${payload['deviceId']} signedPreKeyId=${payload['signedPreKeyId']}',
          module: 'E2eeCrypto',
        );
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
        _logger.i(
          '[E2EE_TRACE] operation_id=$effectiveOperationId stage=device_identity_registration_success event=success',
          module: 'E2eeCrypto',
        );
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

  Future<SignalCiphertextEnvelope> encryptOutboundMessage(
    String recipientUserId,
    String plaintext, {
    int? recipientDeviceId,
    String? senderDeviceId,
    String? operationId,
  }) async {
    final effectiveOperationId = _resolveOperationId(operationId);
    var resolvedRecipientDeviceId = recipientDeviceId;
    if (resolvedRecipientDeviceId == null || resolvedRecipientDeviceId <= 0) {
      final remoteBundle = await fetchRemotePreKeyBundle(
        recipientUserId,
        operationId: effectiveOperationId,
      );
      resolvedRecipientDeviceId = remoteBundle.getDeviceId();
    }
    if (resolvedRecipientDeviceId <= 0) {
      throw const FormatException('Signal recipient device id is required');
    }

    var address = SignalProtocolAddress(
      recipientUserId,
      resolvedRecipientDeviceId,
    );
    _logger.i(
      '[E2EE_TRACE] operation_id=$effectiveOperationId stage=encrypt_start event=start recipient_user_id=$recipientUserId sender_app_device_id=${senderDeviceId ?? "unknown"} signal_address=${_signalAddressName(address)} plaintext_length=${plaintext.length}',
      module: 'E2eeCrypto',
    );
    try {
      final sessionExists = await _signalStore.containsSession(address);
      _logger.i(
        '[E2EE_TRACE] operation_id=$effectiveOperationId stage=session_presence_check event=success recipient_user_id=$recipientUserId signal_address=${_signalAddressName(address)} session_exists=$sessionExists',
        module: 'E2eeCrypto',
      );
      if (!sessionExists) {
        await registerDeviceIdentityWithOperation(effectiveOperationId);
        final remoteBundle = await fetchRemotePreKeyBundle(
          recipientUserId,
          operationId: effectiveOperationId,
        );
        resolvedRecipientDeviceId = remoteBundle.getDeviceId();
        address = SignalProtocolAddress(
          recipientUserId,
          resolvedRecipientDeviceId,
        );
        _logger.i(
          '[E2EE_TRACE] operation_id=$effectiveOperationId stage=outbound_bundle_loaded event=success recipient_user_id=$recipientUserId bundle_device_id=$resolvedRecipientDeviceId bundle_identity_fingerprint=${fingerprintIdentityKey(remoteBundle.getIdentityKey())}',
          module: 'E2eeCrypto',
        );
        await initializeSessionForPeer(
          recipientUserId,
          remoteBundle: remoteBundle,
          deviceId: resolvedRecipientDeviceId,
          operationId: effectiveOperationId,
        );
      }

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
      _logger.i(
        '[E2EE_TRACE] operation_id=$effectiveOperationId stage=encrypt_success event=success recipient_user_id=$recipientUserId signal_address=${_signalAddressName(address)} signal_type=${envelope.type} ciphertext_len=${envelope.ciphertext.length}',
        module: 'E2eeCrypto',
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

    if (candidateDeviceIds.isEmpty) {
      final senderAppDeviceId = requireAppDeviceUuid(
        trimmedSenderDeviceId,
        context: 'sender_device_id',
      );
      if (Uuid.isValidUUID(fromString: senderAppDeviceId)) {
        throw const FormatException(
          'Inbound sender app UUID cannot be used as a Signal device id; no valid local numeric Signal session exists for this sender',
        );
      }
      throw const FormatException(
        'No valid numeric Signal device id was found for this inbound message; local session data is missing or stale',
      );
    }

    Object? lastError;
    for (final candidateDeviceId in candidateDeviceIds) {
      final address = SignalProtocolAddress(senderUserId, candidateDeviceId);
      _logger.i(
        '[E2EE_TRACE] operation_id=$effectiveOperationId stage=decrypt_start event=start sender_user_id=$senderUserId sender_device_id=$trimmedSenderDeviceId signal_device_id=$candidateDeviceId signal_address=${_signalAddressName(address)} signal_type=$type ciphertext_len=${ciphertextBase64.length}',
        module: 'E2eeCrypto',
      );

      try {
        final trustedIdentity = await _signalStore.getIdentity(address);
        _logger.i(
          '[E2EE_TRACE] operation_id=$effectiveOperationId stage=decrypt_identity_loaded event=success sender_user_id=$senderUserId signal_address=${_signalAddressName(address)} trusted_identity_fingerprint=${fingerprintIdentityKey(trustedIdentity)}',
          module: 'E2eeCrypto',
        );
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
        _logger.i(
          '[E2EE_TRACE] operation_id=$effectiveOperationId stage=decrypt_success event=success sender_user_id=$senderUserId signal_address=${_signalAddressName(address)} plaintext_len=${decoded.length} signal_type=$type',
          module: 'E2eeCrypto',
        );
        return decoded;
      } catch (e, st) {
        lastError = e;
        _logger.w(
          '[E2EE_TRACE] operation_id=$effectiveOperationId stage=decrypt_candidate_failed event=warning sender_user_id=$senderUserId signal_address=${_signalAddressName(address)} signal_device_id=$candidateDeviceId signal_type=$type error_type=${e.runtimeType} error_message=${e.toString()}',
          error: e,
          stackTrace: st,
          module: 'E2eeCrypto',
        );
      }
    }

    final lastErrorMessage = lastError?.toString() ?? 'unknown';
    throw EncryptionFailureException(
      'Nie można odszyfrować wiadomości od użytkownika $senderUserId. Nie ma poprawnego numeru Signal device id dla sesji lokalnej i nie wolno zgadywać UUID jako device id. Ostatni błąd: $lastErrorMessage',
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
  final signalStore = DriftSignalProtocolStore(db);

  return E2eeCryptoService(
    secureStorage,
    logger,
    apiClient,
    deviceInfoService,
    signalStore,
  );
}
