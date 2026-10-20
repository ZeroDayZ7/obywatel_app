import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

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
    final typeValue = json['type'];
    final parsedType = typeValue is int
        ? typeValue
        : typeValue == null
            ? null
            : int.tryParse(typeValue.toString());

    if (parsedType == null ||
        !{
          CiphertextMessage.whisperType,
          CiphertextMessage.prekeyType,
          CiphertextMessage.senderKeyType,
        }.contains(parsedType)) {
      throw const FormatException(
        'Signal ciphertext type is missing or invalid; refusing to infer a fallback type.',
      );
    }

    final ciphertext = (json['ciphertext'] ?? '').toString().trim();
    final senderDeviceId = (json['senderDeviceId'] ?? '').toString().trim();
    final recipientUserId = (json['recipientUserId'] ?? '').toString().trim();
    final recipientDeviceId = (json['recipientDeviceId'] ?? '').toString().trim();

    if (ciphertext.isEmpty) {
      throw const FormatException(
        'Signal ciphertext payload is missing.',
      );
    }
    if (senderDeviceId.isEmpty) {
      throw const FormatException(
        'Signal senderDeviceId is required and cannot be blank.',
      );
    }
    if (recipientUserId.isEmpty) {
      throw const FormatException(
        'Signal recipientUserId is required and cannot be blank.',
      );
    }
    if (recipientDeviceId.isEmpty || int.tryParse(recipientDeviceId) == null || int.parse(recipientDeviceId) <= 0) {
      throw const FormatException(
        'Signal recipientDeviceId is required and must be a positive numeric device id.',
      );
    }

    return SignalCiphertextEnvelope(
      type: parsedType,
      ciphertext: ciphertext,
      senderDeviceId: senderDeviceId,
      recipientUserId: recipientUserId,
      recipientDeviceId: recipientDeviceId,
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

class DeviceKeyBundle {
  final String deviceId;
  final int registrationId;
  final String publicKey;
  final String signedPreKey;
  final String signedPreKeySignature;
  final int signedPreKeyId;
  final List<OneTimePreKeyRegistration> oneTimePreKeys;

  const DeviceKeyBundle({
    required this.deviceId,
    required this.registrationId,
    required this.publicKey,
    required this.signedPreKey,
    required this.signedPreKeySignature,
    required this.signedPreKeyId,
    required this.oneTimePreKeys,
  });

  Map<String, dynamic> toRegistrationPayload() => {
    'deviceId': deviceId,
    'registrationId': registrationId,
    'identityPublicKey': publicKey,
    'publicKey': publicKey,
    'signedPreKey': signedPreKey,
    'signedPreKeySig': signedPreKeySignature,
    'signedPreKeyId': signedPreKeyId,
    'oneTimePreKeys': oneTimePreKeys.map((preKey) => preKey.toJson()).toList(),
  };
}

class LocalDeviceKeyBundle extends DeviceKeyBundle {
  final String privateKey;

  const LocalDeviceKeyBundle({
    required super.deviceId,
    required super.registrationId,
    required super.publicKey,
    required this.privateKey,
    required super.signedPreKey,
    required super.signedPreKeySignature,
    required super.signedPreKeyId,
    required super.oneTimePreKeys,
  });

  DeviceKeyBundle toRegistrationBundle() => DeviceKeyBundle(
    deviceId: deviceId,
    registrationId: registrationId,
    publicKey: publicKey,
    signedPreKey: signedPreKey,
    signedPreKeySignature: signedPreKeySignature,
    signedPreKeyId: signedPreKeyId,
    oneTimePreKeys: oneTimePreKeys,
  );
}
