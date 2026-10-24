import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:obywatel_plus/core/crypto/drift_signal_protocol_store.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/features/communication/application/e2ee_crypto_service.dart';

enum ContactIdentityVerificationStatus {
  unknown,
  unverified,
  verified,
  changed,
}

class ContactIdentityVerificationState {
  const ContactIdentityVerificationState({
    required this.status,
    this.fingerprint,
    this.deviceId,
    this.previousFingerprint,
    this.verifiedAtIso,
  });

  final ContactIdentityVerificationStatus status;
  final String? fingerprint;
  final int? deviceId;
  final String? previousFingerprint;
  final String? verifiedAtIso;

  bool get hasKnownIdentity => fingerprint != null && fingerprint!.isNotEmpty;
  bool get isVerified => status == ContactIdentityVerificationStatus.verified;
  bool get isChanged => status == ContactIdentityVerificationStatus.changed;
}

class ContactIdentityVerificationService {
  ContactIdentityVerificationService({
    required AppDatabase db,
    required SecureStorageService secureStorage,
    required AppLogger logger,
    E2eeCryptoService? e2eeCryptoService,
  }) : _db = db,
       _secureStorage = secureStorage,
       _logger = logger;

  static const String _verificationStoragePrefix =
      'signal_identity_verification_';

  final AppDatabase _db;
  final SecureStorageService _secureStorage;
  final AppLogger _logger;

  String _storageKeyFor(String userId, int deviceId) {
    final sanitizedUserId = userId.trim();
    return '$_verificationStoragePrefix${base64Url.encode(utf8.encode(sanitizedUserId))}_$deviceId';
  }

  Future<int?> _resolveKnownDeviceId(String contactUserId) async {
    final store = DriftSignalProtocolStore(_db, logger: _logger);
    final deviceIds = await store.getSubDeviceSessions(contactUserId);
    final knownIds = deviceIds.where((deviceId) => deviceId > 0).toList();
    if (knownIds.isEmpty) {
      return null;
    }
    knownIds.sort();
    return knownIds.first;
  }

  Future<_PersistedVerificationRecord?> _readPersistedVerification(
    String contactUserId,
    int deviceId,
  ) async {
    final rawValue = await _secureStorage.read(
      key: _storageKeyFor(contactUserId, deviceId),
    );
    if (rawValue == null || rawValue.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = Map<String, dynamic>.from(
        jsonDecode(rawValue) as Map<dynamic, dynamic>,
      );
      final savedUserId = decoded['userId']?.toString();
      final savedDeviceId = int.tryParse(decoded['deviceId']?.toString() ?? '');
      final fingerprint = decoded['fingerprint']?.toString();
      if (savedUserId == null || savedUserId != contactUserId.trim()) {
        return null;
      }
      if (savedDeviceId == null || savedDeviceId != deviceId) {
        return null;
      }
      if (fingerprint == null || fingerprint.isEmpty) {
        return null;
      }

      return _PersistedVerificationRecord(
        userId: savedUserId,
        deviceId: savedDeviceId,
        fingerprint: fingerprint,
        verifiedAtIso: decoded['verifiedAt']?.toString(),
      );
    } catch (error, stackTrace) {
      _logger.w(
        '[VERIFY-STATE] unable to decode persistent Signal verification for $contactUserId on device $deviceId',
        error: error,
        stackTrace: stackTrace,
        module: 'ContactIdentityVerificationService',
      );
      return null;
    }
  }

  Future<ContactIdentityVerificationState> resolveForContact(
    String contactUserId, {
    int? deviceId,
  }) async {
    final resolvedDeviceId =
        (deviceId ?? await _resolveKnownDeviceId(contactUserId));
    if (resolvedDeviceId == null || resolvedDeviceId <= 0) {
      return const ContactIdentityVerificationState(
        status: ContactIdentityVerificationStatus.unknown,
      );
    }

    final address = SignalProtocolAddress(contactUserId, resolvedDeviceId);
    final store = DriftSignalProtocolStore(_db, logger: _logger);
    final identity = await store.getIdentity(address);
    if (identity == null) {
      return const ContactIdentityVerificationState(
        status: ContactIdentityVerificationStatus.unknown,
      );
    }

    final fingerprint = E2eeCryptoService.fingerprintIdentityKey(identity);
    final persisted = await _readPersistedVerification(
      contactUserId,
      resolvedDeviceId,
    );
    if (persisted == null) {
      return ContactIdentityVerificationState(
        status: ContactIdentityVerificationStatus.unverified,
        fingerprint: fingerprint,
        deviceId: resolvedDeviceId,
      );
    }

    if (persisted.fingerprint == fingerprint) {
      return ContactIdentityVerificationState(
        status: ContactIdentityVerificationStatus.verified,
        fingerprint: fingerprint,
        deviceId: resolvedDeviceId,
        verifiedAtIso: persisted.verifiedAtIso,
      );
    }

    return ContactIdentityVerificationState(
      status: ContactIdentityVerificationStatus.changed,
      fingerprint: fingerprint,
      deviceId: resolvedDeviceId,
      previousFingerprint: persisted.fingerprint,
      verifiedAtIso: persisted.verifiedAtIso,
    );
  }

  Future<ContactIdentityVerificationState> verifyIdentity(
    String contactUserId, {
    int? deviceId,
  }) async {
    final current = await resolveForContact(contactUserId, deviceId: deviceId);

    _logger.w(
      '[VERIFY-STATE] refusing automatic Signal manual verification for $contactUserId on device ${deviceId ?? 'resolved'}; no real Signal safety-number comparison is implemented yet.',
      module: 'ContactIdentityVerificationService',
    );

    return ContactIdentityVerificationState(
      status: ContactIdentityVerificationStatus.unverified,
      fingerprint: current.fingerprint,
      deviceId: current.deviceId,
      previousFingerprint: current.previousFingerprint,
      verifiedAtIso: current.verifiedAtIso,
    );
  }
}

class _PersistedVerificationRecord {
  const _PersistedVerificationRecord({
    required this.userId,
    required this.deviceId,
    required this.fingerprint,
    required this.verifiedAtIso,
  });

  final String userId;
  final int deviceId;
  final String fingerprint;
  final String? verifiedAtIso;
}

final contactIdentityVerificationServiceProvider =
    Provider<ContactIdentityVerificationService>((ref) {
      final db = ref.watch(appDatabaseProvider);
      final secureStorage = ref.watch(secureStorageProvider);
      final logger = ref.watch(appLoggerProvider);
      final e2eeCryptoService = ref.watch(e2eeCryptoServiceProvider);

      return ContactIdentityVerificationService(
        db: db,
        secureStorage: secureStorage,
        logger: logger,
        e2eeCryptoService: e2eeCryptoService,
      );
    });

final contactIdentityVerificationProvider =
    FutureProvider.family<ContactIdentityVerificationState, String>((
      ref,
      contactUserId,
    ) async {
      final service = ref.watch(contactIdentityVerificationServiceProvider);
      return service.resolveForContact(contactUserId);
    });
