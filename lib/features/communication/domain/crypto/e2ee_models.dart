import 'dart:convert';

import 'package:crypto/crypto.dart';

typedef AppDeviceUuid = String;
typedef SignalDeviceId = int;

class EncryptedData {
  final String ciphertextBase64;
  final String nonceBase64;
  final int type;

  const EncryptedData({
    required this.ciphertextBase64,
    required this.nonceBase64,
    required this.type,
  });
}

class SignalCiphertextEnvelope {
  final int type;
  final String ciphertext;
  final String senderDeviceId;
  final String recipientUserId;
  final String recipientDeviceId;

  const SignalCiphertextEnvelope({
    required this.type,
    required this.ciphertext,
    required this.senderDeviceId,
    required this.recipientUserId,
    required this.recipientDeviceId,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'ciphertext': ciphertext,
    'senderDeviceId': senderDeviceId,
    'recipientUserId': recipientUserId,
    'recipientDeviceId': recipientDeviceId,
  };

  factory SignalCiphertextEnvelope.fromJson(Map<String, dynamic> json) {
    final typeValue = json['type'] ?? 1;
    return SignalCiphertextEnvelope(
      type: typeValue is int
          ? typeValue
          : int.tryParse(typeValue.toString()) ?? 1,
      ciphertext: (json['ciphertext'] ?? '').toString(),
      senderDeviceId: (json['senderDeviceId'] ?? '').toString(),
      recipientUserId: (json['recipientUserId'] ?? '').toString(),
      recipientDeviceId: (json['recipientDeviceId'] ?? '1').toString(),
    );
  }
}

class OneTimePreKeyRegistration {
  final int keyId;
  final String publicKey;

  const OneTimePreKeyRegistration({
    required this.keyId,
    required this.publicKey,
  });

  Map<String, dynamic> toJson() => {'keyId': keyId, 'publicKey': publicKey};
}

class DeviceKeyRegistrationRequest {
  final String deviceId;
  final int registrationId;
  final String identityPublicKey;
  final String signedPreKey;
  final String signedPreKeySignature;
  final int signedPreKeyId;
  final List<OneTimePreKeyRegistration> oneTimePreKeys;

  const DeviceKeyRegistrationRequest({
    required this.deviceId,
    required this.registrationId,
    required this.identityPublicKey,
    required this.signedPreKey,
    required this.signedPreKeySignature,
    required this.signedPreKeyId,
    required this.oneTimePreKeys,
  });

  Map<String, dynamic> toJson() => {
    'deviceId': deviceId,
    'registrationId': registrationId,
    'identityPublicKey': identityPublicKey,
    'signedPreKey': signedPreKey,
    'signedPreKeySig': signedPreKeySignature,
    'signedPreKeyId': signedPreKeyId,
    'oneTimePreKeys': oneTimePreKeys.map((key) => key.toJson()).toList(),
  };
}

class LocalDeviceIdentityMaterial {
  final String deviceId;
  final int registrationId;
  final String identityPublicKey;
  final String privateKey;
  final String signedPreKey;
  final String signedPreKeySignature;
  final int signedPreKeyId;
  final List<OneTimePreKeyRegistration> oneTimePreKeys;

  const LocalDeviceIdentityMaterial({
    required this.deviceId,
    required this.registrationId,
    required this.identityPublicKey,
    required this.privateKey,
    required this.signedPreKey,
    required this.signedPreKeySignature,
    required this.signedPreKeyId,
    required this.oneTimePreKeys,
  });

  DeviceKeyRegistrationRequest toRegistrationRequest() =>
      DeviceKeyRegistrationRequest(
        deviceId: deviceId,
        registrationId: registrationId,
        identityPublicKey: identityPublicKey,
        signedPreKey: signedPreKey,
        signedPreKeySignature: signedPreKeySignature,
        signedPreKeyId: signedPreKeyId,
        oneTimePreKeys: oneTimePreKeys,
      );
}

class DeviceKeyBundle extends LocalDeviceIdentityMaterial {
  const DeviceKeyBundle({
    required super.deviceId,
    required super.registrationId,
    required super.identityPublicKey,
    required super.privateKey,
    required super.signedPreKey,
    required super.signedPreKeySignature,
    required super.signedPreKeyId,
    required super.oneTimePreKeys,
  });
}

class DeviceRegistrationMarker {
  static const int version = 1;

  final int versionCode;
  final String deviceId;
  final int registrationId;
  final String identityPublicKeyFingerprint;
  final int signedPreKeyId;

  const DeviceRegistrationMarker({
    required this.versionCode,
    required this.deviceId,
    required this.registrationId,
    required this.identityPublicKeyFingerprint,
    required this.signedPreKeyId,
  });

  factory DeviceRegistrationMarker.fromLocalMaterial(
    LocalDeviceIdentityMaterial material,
  ) {
    final fingerprint = sha256
        .convert(base64Decode(material.identityPublicKey))
        .toString();
    return DeviceRegistrationMarker(
      versionCode: version,
      deviceId: material.deviceId,
      registrationId: material.registrationId,
      identityPublicKeyFingerprint: fingerprint,
      signedPreKeyId: material.signedPreKeyId,
    );
  }

  factory DeviceRegistrationMarker.fromStored(String rawValue) {
    final decoded = jsonDecode(rawValue);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid E2EE registration marker format; expected JSON object.',
      );
    }

    final versionCode = decoded['version'] is int
        ? decoded['version'] as int
        : int.tryParse(decoded['version']?.toString() ?? '');
    if (versionCode == null || versionCode != version) {
      throw const FormatException(
        'Unsupported E2EE registration marker version.',
      );
    }

    final deviceId = decoded['deviceId']?.toString();
    final registrationId = decoded['registrationId'] is int
        ? decoded['registrationId'] as int
        : int.tryParse(decoded['registrationId']?.toString() ?? '');
    final fingerprint = decoded['identityPublicKeyFingerprint']?.toString();
    final signedPreKeyId = decoded['signedPreKeyId'] is int
        ? decoded['signedPreKeyId'] as int
        : int.tryParse(decoded['signedPreKeyId']?.toString() ?? '');

    if (deviceId == null ||
        registrationId == null ||
        fingerprint == null ||
        signedPreKeyId == null) {
      throw const FormatException(
        'E2EE registration marker is missing required fields.',
      );
    }

    return DeviceRegistrationMarker(
      versionCode: version,
      deviceId: deviceId,
      registrationId: registrationId,
      identityPublicKeyFingerprint: fingerprint,
      signedPreKeyId: signedPreKeyId,
    );
  }

  bool matches(LocalDeviceIdentityMaterial material) {
    final expected = DeviceRegistrationMarker.fromLocalMaterial(material);
    return versionCode == expected.versionCode &&
        deviceId == expected.deviceId &&
        registrationId == expected.registrationId &&
        identityPublicKeyFingerprint == expected.identityPublicKeyFingerprint &&
        signedPreKeyId == expected.signedPreKeyId;
  }

  String toPersistedValue() => jsonEncode({
    'version': versionCode,
    'deviceId': deviceId,
    'registrationId': registrationId,
    'identityPublicKeyFingerprint': identityPublicKeyFingerprint,
    'signedPreKeyId': signedPreKeyId,
  });
}
