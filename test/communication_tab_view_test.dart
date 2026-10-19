import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/communication/communication_tab_view.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/messages/message_bubble.dart';

void main() {
  testWidgets('communication navigation includes all four sections', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CommunicationNavigationShell(
            selectedIndex: 0,
            onSelected: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Wiadomości'), findsOneWidget);
    expect(find.text('Kontakty'), findsOneWidget);
    expect(find.text('Połączenia'), findsOneWidget);
    expect(find.text('Grupy'), findsOneWidget);
  });

  testWidgets('desktop rail supports expand and collapse toggle', (
    tester,
  ) async {
    var selectedIndex = 0;
    var isExpanded = true;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: 1200,
              height: 800,
              child: CommunicationNavigationShell(
                selectedIndex: selectedIndex,
                isExpanded: isExpanded,
                onSelected: (index) => setState(() => selectedIndex = index),
                onToggleExpanded: () =>
                    setState(() => isExpanded = !isExpanded),
              ),
            );
          },
        ),
      ),
    );

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byTooltip('Zwiń panel nawigacji'), findsOneWidget);

    await tester.tap(find.byTooltip('Zwiń panel nawigacji'));
    await tester.pump();

    expect(find.byTooltip('Rozwiń panel nawigacji'), findsOneWidget);
    expect(selectedIndex, 0);
  });

  test(
    'hero tags stay unique for different messages sharing one attachment id',
    () {
      final first = MessageBubble.heroTagForMessage(
        messageId: 'message-1',
        attachmentId: 'shared-attachment',
      );
      final second = MessageBubble.heroTagForMessage(
        messageId: 'message-2',
        attachmentId: 'shared-attachment',
      );

      expect(first, isNot(equals(second)));
      expect(first, equals('message-message-1-attachment-shared-attachment'));
      expect(second, equals('message-message-2-attachment-shared-attachment'));
    },
  );

  test('hero tags remain unique when message id is empty', () {
    final first = MessageBubble.heroTagForMessage(
      messageId: '',
      attachmentId: 'attachment-1',
    );
    final second = MessageBubble.heroTagForMessage(
      messageId: '',
      attachmentId: 'attachment-2',
    );

    expect(first, isNot(equals(second)));
    expect(first, equals('attachment-attachment-1'));
    expect(second, equals('attachment-attachment-2'));
  });
}
