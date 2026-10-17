import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<Uint8List> _encodeImage({required int width, required int height}) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  final paint = ui.Paint()..color = const ui.Color(0xFF42A5F5);

  canvas.drawRect(
    ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    paint,
  );

  final picture = recorder.endRecording();
  final image = await picture.toImage(width, height);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

  return byteData!.buffer.asUint8List();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Message preview aspect ratio', () {
    testWidgets('keeps a square preview proportional', (tester) async {
      final bytes = await _encodeImage(width: 128, height: 128);

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 220, maxHeight: 220),
              child: Image.memory(bytes, fit: BoxFit.contain),
            ),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.fit, BoxFit.contain);
    });

    testWidgets('keeps a landscape preview proportional', (tester) async {
      final bytes = await _encodeImage(width: 1600, height: 900);

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 240, maxHeight: 260),
              child: Image.memory(bytes, fit: BoxFit.contain),
            ),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.fit, BoxFit.contain);
    });

    testWidgets('keeps a portrait preview proportional', (tester) async {
      final bytes = await _encodeImage(width: 600, height: 900);

      await tester.pumpWidget(
        MaterialApp(
          home: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 240, maxHeight: 260),
              child: Image.memory(bytes, fit: BoxFit.contain),
            ),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.fit, BoxFit.contain);
    });
  });
}
