import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/storage/local_attachment_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final rootDirectory = Directory.systemTemp.createTempSync(
    'local_attachment_store_test',
  );

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (methodCall) async {
        switch (methodCall.method) {
          case 'getApplicationSupportDirectory':
            return rootDirectory.path;
          case 'getTemporaryDirectory':
            return rootDirectory.path;
          case 'getApplicationDocumentsDirectory':
            return rootDirectory.path;
          default:
            return null;
        }
      },
    );
  });

  tearDownAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      null,
    );
    if (rootDirectory.existsSync()) {
      rootDirectory.deleteSync(recursive: true);
    }
  });

  group('LocalAttachmentStore', () {
    test('stores attachment bytes in a public local file location', () async {
      final store = LocalAttachmentStore();
      const attachmentId = 'attachment-123';
      final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);

      final savedPath = await store.saveAttachment(
        attachmentId: attachmentId,
        bytes: bytes,
        mimeType: 'image/png',
        fileName: 'photo.png',
      );

      final file = File(savedPath);
      expect(await file.exists(), isTrue);
      expect(await file.readAsBytes(), equals(bytes));
      expect(
        await store.readAttachment(
          attachmentId: attachmentId,
          mimeType: 'image/png',
          fileName: 'photo.png',
        ),
        equals(bytes),
      );
    });

    test('stores and reads thumbnail bytes from app cache', () async {
      final store = LocalAttachmentStore();
      const attachmentId = 'attachment-thumb';
      final thumbnail = Uint8List.fromList([7, 8, 9]);

      await store.saveThumbnail(
        attachmentId: attachmentId,
        bytes: thumbnail,
      );

      final saved = await store.readThumbnail(attachmentId);
      expect(saved, equals(thumbnail));
    });

    test('returns null for a missing attachment file', () async {
      final store = LocalAttachmentStore();
      const attachmentId = 'missing-attachment-456';

      final preview = await store.readAttachment(
        attachmentId: attachmentId,
        mimeType: 'image/png',
        fileName: 'missing.png',
      );
      expect(preview, isNull);
    });
  });
}
