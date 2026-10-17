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

class DeviceKeyBundle {
  final String deviceId;
  final int registrationId;
  final String publicKey;
  final String privateKey;
  final String signedPreKey;
  final String signedPreKeySignature;
  final int signedPreKeyId;
  final List<OneTimePreKeyRegistration> oneTimePreKeys;

  const DeviceKeyBundle({
    required this.deviceId,
    required this.registrationId,
    required this.publicKey,
    required this.privateKey,
    required this.signedPreKey,
    required this.signedPreKeySignature,
    required this.signedPreKeyId,
    required this.oneTimePreKeys,
  });
}
