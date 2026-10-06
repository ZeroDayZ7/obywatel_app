import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/evoting/presentation/pages/evoting_screen.dart';
import 'package:obywatel_plus/features/home/presentation/pages/quick_access_screen.dart';

void main() {
  testWidgets('Quick access exposes separate liquid democracy and market tiles', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: QuickAccessScreen()));

    expect(find.text('Płynna Demokracja'), findsOneWidget);
    expect(find.text('Giełda Polityków'), findsOneWidget);
  });

  testWidgets('EVoting screen no longer advertises the delegation market banner', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: EVotingScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Giełda delegacji'), findsNothing);
  });
}
