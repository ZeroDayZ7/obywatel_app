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
        if (methodCall.method == 'getApplicationSupportDirectory') {
          return rootDirectory.path;
        }
        return null;
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
    test('stores preview bytes in app-local file storage', () async {
      final store = LocalAttachmentStore();
      const attachmentId = 'attachment-123';
      final preview = Uint8List.fromList([1, 2, 3, 4, 5]);

      await store.savePreview(attachmentId, preview);

      final saved = await store.readPreview(attachmentId);
      expect(saved, equals(preview));

      final path = await store.previewPathForAttachment(attachmentId);
      final file = File(path);
      expect(await file.exists(), isTrue);
      expect(await file.readAsBytes(), equals(preview));
    });

    test('returns null for a missing preview file', () async {
      final store = LocalAttachmentStore();
      const attachmentId = 'missing-attachment-456';

      final preview = await store.readPreview(attachmentId);
      expect(preview, isNull);
    });
  });
}
