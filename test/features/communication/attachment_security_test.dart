import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/crypto/symmetric_crypto.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/storage/local_attachment_store.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/attachment_preview_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final documentsRoot = Directory.systemTemp.createTempSync('app_docs');
  final tempRoot = Directory.systemTemp.createTempSync('app_temp');
  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(pathProviderChannel, (call) async {
        switch (call.method) {
          case 'getApplicationDocumentsDirectory':
            return documentsRoot.path;
          case 'getTemporaryDirectory':
            return tempRoot.path;
          default:
            return null;
        }
      });

  group('attachment security validation', () {
    test(
      'rejects a modified plaintext payload when the SHA-256 no longer matches',
      () {
        final bytes = Uint8List.fromList('secret payload'.codeUnits);
        final metadata = {
          'sha256': sha256.convert(bytes).toString(),
          'size': bytes.length,
        };

        final tampered = Uint8List.fromList('secret payload!'.codeUnits);

        expect(
          () =>
              validateAttachmentIntegrity(bytes: tampered, metadata: metadata),
          throwsA(isA<AttachmentIntegrityException>()),
        );
      },
    );

    test('rejects a mismatched plaintext size before exposing the file', () {
      final bytes = Uint8List.fromList('safe'.codeUnits);
      final metadata = {
        'sha256': sha256.convert(bytes).toString(),
        'size': 999,
      };

      expect(
        () => validateAttachmentIntegrity(bytes: bytes, metadata: metadata),
        throwsA(isA<AttachmentIntegrityException>()),
      );
    });

    test(
      'persists validated plaintext bytes, not encrypted payload bytes',
      () async {
        final store = LocalAttachmentStore();
        final plaintext = Uint8List.fromList(
          List<int>.generate(64, (index) => index % 256),
        );
        final crypto = SymmetricCrypto(AppLogger());
        final key = await AesGcm.with256bits().newSecretKey();
        final encryptedBase64 = await crypto.encryptBytes(
          clearBytes: plaintext,
          secretKey: key,
        );
        final decrypted = await crypto.decryptBytes(
          encryptedBase64: encryptedBase64,
          secretKey: key,
        );
        final metadata = {
          'sha256': sha256.convert(decrypted).toString(),
          'size': decrypted.length,
        };

        final savedPath = await persistValidatedAttachment(
          localAttachmentStore: store,
          attachmentId: 'attachment-plaintext-store',
          decryptedBytes: decrypted,
          encryptedBytes: base64Decode(encryptedBase64),
          mimeType: 'application/octet-stream',
          metadata: metadata,
        );

        expect(savedPath, isNotNull);
        final cached = await store.readAttachment(
          attachmentId: 'attachment-plaintext-store',
          mimeType: 'application/octet-stream',
        );
        expect(cached, equals(decrypted));
        expect(cached, isNot(equals(base64Decode(encryptedBase64))));

        final file = File(savedPath!);
        if (await file.exists()) {
          await file.delete();
        }
      },
    );

    test(
      'wrong key or corrupted ciphertext fails closed and never exposes plaintext',
      () async {
        final crypto = SymmetricCrypto(AppLogger());
        final key = await AesGcm.with256bits().newSecretKey();
        final wrongKey = await AesGcm.with256bits().newSecretKey();
        final plaintext = Uint8List.fromList('top secret attachment'.codeUnits);
        final encryptedBase64 = await crypto.encryptBytes(
          clearBytes: plaintext,
          secretKey: key,
        );

        await expectLater(
          () => crypto.decryptBytes(
            encryptedBase64: encryptedBase64,
            secretKey: wrongKey,
          ),
          throwsException,
        );

        final tampered = base64Encode(
          List<int>.from(base64Decode(encryptedBase64))
            ..last = (base64Decode(encryptedBase64).last + 1) % 256,
        );

        await expectLater(
          () => crypto.decryptBytes(encryptedBase64: tampered, secretKey: key),
          throwsException,
        );
      },
    );
  });
}
