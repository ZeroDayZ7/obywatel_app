import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/errors/exceptions/app_exception.dart';
import 'package:obywatel_plus/features/communication/presentation/providers/contacts_provider.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/contacts_error_view.dart';

void main() {
  group('ContactsErrorView', () {
    testWidgets('hides raw exception details and shows network guidance', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            acceptedContactsProvider.overrideWith(
              (ref) => const Stream.empty(),
            ),
          ],
          child: const MaterialApp(
            home: ContactsErrorView(error: NetworkException()),
          ),
        ),
      );

      expect(find.text('Nie udało się pobrać kontaktów'), findsOneWidget);
      expect(
        find.text('Sprawdź połączenie z internetem i spróbuj ponownie.'),
        findsOneWidget,
      );
      expect(find.textContaining('NetworkException'), findsNothing);
      expect(find.textContaining('Exception'), findsNothing);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('shows a generic retry message for non-network errors', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            acceptedContactsProvider.overrideWith(
              (ref) => const Stream.empty(),
            ),
          ],
          child: const MaterialApp(
            home: ContactsErrorView(error: FormatException('bad format')),
          ),
        ),
      );

      expect(find.text('Spróbuj ponownie za chwilę.'), findsOneWidget);
      expect(find.textContaining('FormatException'), findsNothing);

      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();
    });
  });
}
