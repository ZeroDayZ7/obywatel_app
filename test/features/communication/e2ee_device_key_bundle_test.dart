import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/domain/crypto/e2ee_models.dart';

void main() {
  group('DeviceKeyBundle security boundary', () {
    test('registration bundle exposes only public key material', () {
      final bundle = DeviceKeyBundle(
        deviceId: 'device-42',
        registrationId: 7,
        publicKey: 'PUB_KEY',
        signedPreKey: 'PREKEY_PUBLIC',
        signedPreKeySignature: 'SIG',
        signedPreKeyId: 1,
        oneTimePreKeys: const [
          OneTimePreKeyRegistration(keyId: 2, publicKey: 'OTPK_2'),
        ],
      );

      final payload = bundle.toRegistrationPayload();

      expect(payload['deviceId'], 'device-42');
      expect(payload['registrationId'], 7);
      expect(payload['identityPublicKey'], 'PUB_KEY');
      expect(payload['publicKey'], 'PUB_KEY');
      expect(payload['signedPreKey'], 'PREKEY_PUBLIC');
      expect(payload['signedPreKeySig'], 'SIG');
      expect(payload['signedPreKeyId'], 1);
      expect(payload['oneTimePreKeys'], isA<List<dynamic>>());

      expect(payload.containsKey('privateKey'), isFalse);
      expect(payload.containsKey('privateKeyBase64'), isFalse);
      expect(payload.containsKey('private_key'), isFalse);
      expect(payload.containsKey('devicePrivateKey'), isFalse);
      expect(payload.containsKey('device_private_key'), isFalse);
    });

    test('local bundle keeps private key out of registration payload', () {
      final localBundle = LocalDeviceKeyBundle(
        deviceId: 'device-42',
        registrationId: 7,
        publicKey: 'PUB_KEY',
        privateKey: 'PRIVATE_KEY_BYTES',
        signedPreKey: 'PREKEY_PUBLIC',
        signedPreKeySignature: 'SIG',
        signedPreKeyId: 1,
        oneTimePreKeys: const [
          OneTimePreKeyRegistration(keyId: 2, publicKey: 'OTPK_2'),
        ],
      );

      expect(localBundle.privateKey, 'PRIVATE_KEY_BYTES');

      final registrationPayload = localBundle
          .toRegistrationBundle()
          .toRegistrationPayload();

      expect(registrationPayload['identityPublicKey'], 'PUB_KEY');
      expect(registrationPayload.containsKey('privateKey'), isFalse);
      expect(registrationPayload.containsKey('privateKeyBase64'), isFalse);
      expect(registrationPayload.containsKey('device_private_key'), isFalse);
    });
  });
}
