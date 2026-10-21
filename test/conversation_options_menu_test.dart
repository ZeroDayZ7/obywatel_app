import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/conversation_options_menu.dart';

void main() {
  Future<void> openMenu(WidgetTester tester, {ThemeData? theme}) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Scaffold(
          appBar: AppBar(actions: const [ConversationOptionsMenu()]),
          body: const SizedBox(),
        ),
      ),
    );

    await tester.tap(find.byTooltip('More options'));
    await tester.pumpAndSettle();
  }

  testWidgets('More options menu opens and shows all conversation items', (
    WidgetTester tester,
  ) async {
    await openMenu(tester);

    expect(find.text('Szukaj w rozmowie'), findsOneWidget);
    expect(find.text('Multimedia i załączniki'), findsOneWidget);
    expect(find.text('Szczegóły rozmowy'), findsOneWidget);
    expect(find.text('Wycisz powiadomienia'), findsOneWidget);
    expect(find.text('Oznacz jako nieprzeczytane'), findsOneWidget);
    expect(find.text('Archiwizuj rozmowę'), findsOneWidget);
    expect(find.text('Bezpieczeństwo i szyfrowanie'), findsOneWidget);
    expect(find.byType(PopupMenuDivider), findsNWidgets(2));
  });

  testWidgets('Selecting an option closes the menu without errors', (
    WidgetTester tester,
  ) async {
    await openMenu(tester);

    await tester.tap(find.text('Szukaj w rozmowie'));
    await tester.pumpAndSettle();

    expect(find.text('Szukaj w rozmowie'), findsNothing);
  });

  testWidgets('Tapping outside the menu closes it', (
    WidgetTester tester,
  ) async {
    await openMenu(tester);

    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();

    expect(find.text('Szukaj w rozmowie'), findsNothing);
  });

  testWidgets('Menu remains usable in dark theme', (WidgetTester tester) async {
    await openMenu(tester, theme: ThemeData.dark(useMaterial3: true));

    expect(find.byTooltip('More options'), findsOneWidget);
    expect(find.text('Multimedia i załączniki'), findsOneWidget);
  });
}
