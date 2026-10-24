import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/storage/local_attachment_store.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(pathProviderChannel, (call) async {
    switch (call.method) {
      case 'getApplicationDocumentsDirectory':
        return Directory.systemTemp.path;
      case 'getTemporaryDirectory':
        return Directory.systemTemp.path;
      case 'getDownloadsDirectory':
        return Directory.systemTemp.path;
      default:
        return null;
    }
  });

  group('LocalAttachmentStore', () {
    late LocalAttachmentStore store;

    setUp(() {
      store = LocalAttachmentStore();
    });

    test('uses a stable attachment key regardless of original file name', () async {
      final pathA = await store.pathForAttachment(
        'attachment-123',
        mimeType: 'image/png',
        fileName: 'first.png',
      );
      final pathB = await store.pathForAttachment(
        'attachment-123',
        mimeType: 'image/png',
        fileName: 'second.jpg',
      );

      expect(pathA, equals(pathB));
      expect(p.basename(pathA), contains('attachment-123'));
      expect(p.basename(pathA), isNot(contains('first.png')));
    });

    test('stores and reads attachment bytes from the app-private storage location', () async {
      final attachmentId = 'attachment-private-test';
      final bytes = Uint8List.fromList([1, 2, 3, 4, 5, 6]);

      final savedPath = await store.saveAttachment(
        attachmentId: attachmentId,
        bytes: bytes,
        mimeType: 'image/png',
        fileName: 'original.png',
      );

      final appDir = await getApplicationDocumentsDirectory();
      expect(savedPath.startsWith(appDir.path), isTrue,
          reason: 'attachment must be stored in app-private storage, not public Android directories');

      final readBack = await store.readAttachment(
        attachmentId: attachmentId,
        mimeType: 'image/png',
        fileName: 'renamed.png',
      );

      expect(readBack, equals(bytes));
    });
  });
}
