import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/application/contact_identity_verification_service.dart';
import 'package:obywatel_plus/features/communication/domain/contacts/contact.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/communication/communication_tab_view.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/contact_details_sheet.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/contacts_contact_card.dart';

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

  testWidgets('tapping a contact opens the details sheet and chat action', (
    tester,
  ) async {
    const contact = Contact(
      id: 'contact-1',
      ownerId: 'user-a',
      contactUserId: 'user-b',
      status: 'accepted',
      direction: 'incoming',
      displayName: 'Anna Nowak',
      localAlias: 'Anna',
      isOnline: true,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          contactIdentityVerificationProvider.overrideWith((ref, userId) {
            return Future.value(
              const ContactIdentityVerificationState(
                status: ContactIdentityVerificationStatus.unknown,
              ),
            );
          }),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: ContactsContactCard(contact: contact),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Anna'));
    await tester.pumpAndSettle();

    expect(find.byType(ContactDetailsSheet), findsOneWidget);
    expect(find.text('Otwórz bezpieczny czat'), findsOneWidget);
  });
}
