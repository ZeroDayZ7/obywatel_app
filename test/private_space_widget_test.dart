import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/private_space_card.dart';

void main() {
  group('PrivateSpaceCard', () {
    testWidgets('renders card title and preview text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrivateSpaceCard(
              onTap: () {},
              preview: 'Moja prywatna notatka',
            ),
          ),
        ),
      );

      expect(find.text('Notatki dla siebie'), findsOneWidget);
      expect(find.text('Moja prywatna notatka'), findsOneWidget);
    });
  });
}
