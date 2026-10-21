import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/crypto/symmetric_crypto.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

void main() {
  group('database key codec', () {
    test('stores and reads the 32-byte database key as hex without length drift', () {
      final expectedBytes = List<int>.generate(32, (index) => index + 1);
      final hexValue = DatabaseKeyCodec.encodeKeyBytes(expectedBytes);

      final decoded = DatabaseKeyCodec.decodeHexKey(hexValue);

      expect(decoded, equals(expectedBytes));
      expect(decoded.length, equals(32));
    });

    test('rejects invalid non-32-byte application keys before encryption', () {
      const invalidHex = '303132333435363738393a3b3c3d';

      expect(
        () => DatabaseKeyCodec.decodeHexKey(invalidHex),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('symmetric crypto attachment flows', () {
    test('AES-GCM round-trip works with a 32-byte key encoded as hex', () async {
      final keyBytes = List<int>.generate(32, (index) => 17 + index);
      final decodedKey = SecretKey(keyBytes);

      final crypto = SymmetricCrypto(AppLogger());
      final plain = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);

      final encrypted = await crypto.encryptBytes(
        clearBytes: plain,
        secretKey: decodedKey,
      );
      final decrypted = await crypto.decryptBytes(
        encryptedBase64: encrypted,
        secretKey: decodedKey,
      );

      expect(decrypted, equals(plain));
    });
  });
}
