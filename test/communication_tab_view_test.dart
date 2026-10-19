import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/communication/communication_tab_view.dart';

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
}
