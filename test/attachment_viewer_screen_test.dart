import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/domain/chats/message.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/attachment_preview_provider.dart';
import 'package:obywatel_plus/features/communication/presentation/screens/attachment_viewer_screen.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messages/message_bubble.dart';

void main() {
  testWidgets('tap on thumbnail opens full-screen attachment viewer', (
    WidgetTester tester,
  ) async {
    final imageBytes = Uint8List.fromList([1, 2, 3, 4, 5]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          attachmentPreviewProvider(
            'attachment-123',
          ).overrideWith((ref) async => imageBytes),
          attachmentFullImageProvider(
            'attachment-123',
          ).overrideWith((ref) async => imageBytes),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: MessageBubble(
              message: Message(
                id: 'message-1',
                conversationId: 'conversation-1',
                senderId: 'user-1',
                content: '',
                isMine: true,
                createdAt: DateTime.now(),
                status: 'sent',
                attachmentId: 'attachment-123',
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byType(Image).first);
    await tester.pumpAndSettle();

    expect(find.byType(AttachmentViewerScreen), findsOneWidget);
    final screen = tester.widget<AttachmentViewerScreen>(
      find.byType(AttachmentViewerScreen),
    );
    expect(screen.attachmentId, 'attachment-123');
  });

  testWidgets('viewer shows loading state while image is being loaded', (
    WidgetTester tester,
  ) async {
    final completer = Completer<Uint8List>();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          attachmentFullImageProvider(
            'attachment-456',
          ).overrideWith((ref) => completer.future),
        ],
        child: const MaterialApp(
          home: AttachmentViewerScreen(attachmentId: 'attachment-456'),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(Uint8List.fromList([8, 9, 10]));
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('viewer shows error state when decrypt or fetch fails', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          attachmentFullImageProvider(
            'attachment-789',
          ).overrideWith((ref) async => throw Exception('boom')),
        ],
        child: const MaterialApp(
          home: AttachmentViewerScreen(attachmentId: 'attachment-789'),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Nie udało się odczytać załącznika.'), findsOneWidget);
  });

  testWidgets(
    'viewer close button is safe even while async image load is pending',
    (WidgetTester tester) async {
      final completer = Completer<Uint8List>();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            attachmentFullImageProvider(
              'attachment-close',
            ).overrideWith((ref) => completer.future),
          ],
          child: const MaterialApp(
            home: AttachmentViewerScreen(attachmentId: 'attachment-close'),
          ),
        ),
      );

      expect(find.byTooltip('Zamknij'), findsOneWidget);

      await tester.tap(find.byTooltip('Zamknij'));
      await tester.pump();

      completer.complete(Uint8List.fromList([1, 2, 3]));
      await tester.pump();

      expect(tester.takeException(), isNull);
    },
  );
}
