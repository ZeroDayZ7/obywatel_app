import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';
import 'package:obywatel_plus/features/communication/domain/crypto/e2ee_models.dart';

String requireAppDeviceUuid(
  String? rawAppDeviceId, {
  String context = 'app_device_id',
}) {
  final normalized = (rawAppDeviceId ?? '').trim();
  if (normalized.isEmpty) {
    throw FormatException('Missing $context; raw app device UUID is required');
  }
  return normalized;
}

SignalDeviceId resolveSignalDeviceId(
  String? rawDeviceId, {
  SignalDeviceId? fallback,
}) {
  final trimmed = (rawDeviceId ?? '').trim();
  if (trimmed.isEmpty) {
    if (fallback != null) return fallback;
    throw const FormatException(
      'Signal device id is missing; the bundle must include a positive numeric device id.',
    );
  }

  final numeric = int.tryParse(trimmed);
  if (numeric != null && numeric > 0) {
    return numeric;
  }

  if (fallback != null) return fallback;
  throw const FormatException(
    'Signal device id is invalid; it must be a positive integer. UUID-based device hashing is not allowed because it creates collisions between different app devices of the same user.',
  );
}

SignalDeviceId resolveSignalDeviceIdFromAppUuid(
  AppDeviceUuid? rawAppDeviceUuid, {
  SignalDeviceId? fallback,
}) {
  requireAppDeviceUuid(
    rawAppDeviceUuid,
    context: 'app_device_id',
  );
  if (fallback != null) return fallback;
  throw const FormatException(
    'App device UUID is not a Signal device id; the server must supply a numeric signal device id from the device registration bundle.',
  );
}

String fingerprintIdentityKey(IdentityKey? identityKey) {
  if (identityKey == null) {
    return 'missing';
  }

  final digest = sha256.convert(identityKey.serialize());
  return digest.toString();
}

PreKeyBundle fromPreKeyBundleJson(Map<String, dynamic> json) {
  final registrationIdValue = json['registrationId'];
  final int registrationId;
  if (registrationIdValue is int) {
    registrationId = registrationIdValue;
  } else if (registrationIdValue == null) {
    throw const FormatException(
      'Missing required Signal bundle field: registrationId',
    );
  } else {
    final parsed = int.tryParse(registrationIdValue.toString());
    if (parsed == null) {
      throw const FormatException(
        'Missing required Signal bundle field: registrationId',
      );
    }
    registrationId = parsed;
  }
  if (registrationId <= 0) {
    throw const FormatException(
      'Signal bundle registrationId must be a positive integer.',
    );
  }

  final rawDeviceId = json['deviceId'];
  final int deviceId;
  if (rawDeviceId is int) {
    deviceId = resolveSignalDeviceId(rawDeviceId.toString());
  } else if (rawDeviceId is String) {
    deviceId = resolveSignalDeviceId(rawDeviceId);
  } else {
    throw const FormatException(
      'Missing required Signal bundle field: deviceId',
    );
  }

  final preKeyIdValue = json['preKeyId'];
  final int? preKeyId;
  if (preKeyIdValue == null || preKeyIdValue.toString().trim().isEmpty) {
    preKeyId = null;
  } else if (preKeyIdValue is int) {
    preKeyId = preKeyIdValue;
  } else {
    preKeyId = int.tryParse(preKeyIdValue.toString());
  }

  final signedPreKeyIdValue = json['signedPreKeyId'];
  final int signedPreKeyId;
  if (signedPreKeyIdValue is int) {
    signedPreKeyId = signedPreKeyIdValue;
  } else if (signedPreKeyIdValue == null) {
    throw const FormatException(
      'Missing required Signal bundle field: signedPreKeyId',
    );
  } else {
    final parsed = int.tryParse(signedPreKeyIdValue.toString());
    if (parsed == null) {
      throw const FormatException(
        'Missing required Signal bundle field: signedPreKeyId',
      );
    }
    signedPreKeyId = parsed;
  }
  if (signedPreKeyId <= 0) {
    throw const FormatException(
      'Signal bundle signedPreKeyId must be a positive integer.',
    );
  }

  final identityKeyRaw = json['identityKey'];
  final identityKeyBytes = identityKeyRaw is String && identityKeyRaw.isNotEmpty
      ? base64Decode(identityKeyRaw)
      : null;

  final signedPreKeyPublicRaw = json['signedPreKeyPublic'];
  final signedPreKeyPublicBytes =
      signedPreKeyPublicRaw is String && signedPreKeyPublicRaw.isNotEmpty
      ? base64Decode(signedPreKeyPublicRaw)
      : null;

  final signedPreKeySignatureRaw = json['signedPreKeySignature'];
  final signedPreKeySignatureBytes =
      signedPreKeySignatureRaw is String && signedPreKeySignatureRaw.isNotEmpty
      ? base64Decode(signedPreKeySignatureRaw)
      : null;

  final preKeyPublicRaw = json['preKeyPublic'];
  final preKeyPublicBytes =
      preKeyPublicRaw is String && preKeyPublicRaw.isNotEmpty
      ? base64Decode(preKeyPublicRaw)
      : null;

  if (identityKeyBytes == null ||
      signedPreKeyPublicBytes == null ||
      signedPreKeySignatureBytes == null) {
    throw const FormatException(
      'Missing required Signal pre-key bundle fields',
    );
  }

  final identityKey = IdentityKey.fromBytes(identityKeyBytes, 0);
  final signedPreKeyPublic = Curve.decodePoint(signedPreKeyPublicBytes, 0);
  final preKeyPublic =
      preKeyPublicBytes == null ? null : Curve.decodePoint(preKeyPublicBytes, 0);

  return PreKeyBundle(
    registrationId,
    deviceId,
    preKeyId == 0 ? null : preKeyId,
    preKeyPublic,
    signedPreKeyId,
    signedPreKeyPublic,
    signedPreKeySignatureBytes,
    identityKey,
  );
}
