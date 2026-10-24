import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/attachment_preview_provider.dart';
import 'package:obywatel_plus/features/communication/presentation/screens/attachment_viewer_screen.dart';

void main() {
  group('Attachment integrity validation', () {
    test('accepts matching plaintext hashes and sizes', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final metadata = {
        'sha256': sha256.convert(bytes).toString(),
        'size': bytes.length,
      };

      expect(
        () => validateAttachmentIntegrity(bytes: bytes, metadata: metadata),
        returnsNormally,
      );
    });

    test('rejects mismatched hashes before preview is accepted', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      final metadata = {
        'sha256': sha256.convert(Uint8List.fromList([9, 9, 9])).toString(),
        'size': bytes.length,
      };

      expect(
        () => validateAttachmentIntegrity(bytes: bytes, metadata: metadata),
        throwsA(isA<AttachmentIntegrityException>()),
      );
    });
  });

  group('Attachment viewer fullscreen behavior', () {
    testWidgets(
      'uses an InteractiveViewer that fills the available preview area',
      (tester) async {
        final imageBytes = Uint8List.fromList([
          0x89,
          0x50,
          0x4E,
          0x47,
          0x0D,
          0x0A,
          0x1A,
          0x0A,
        ]);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              attachmentFullImageProvider.overrideWith(
                (ref, arg) => Future.value(imageBytes),
              ),
            ],
            child: const MaterialApp(
              home: AttachmentViewerScreen(attachmentId: 'abc123'),
            ),
          ),
        );

        await tester.pump();

        final viewer = tester.widget<InteractiveViewer>(
          find.byType(InteractiveViewer),
        );

        expect(find.byType(InteractiveViewer), findsOneWidget);
        expect(viewer.constrained, isFalse);
        expect(viewer.maxScale, greaterThan(1.0));
      },
    );
  });
}
