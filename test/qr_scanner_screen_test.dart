import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/qr_scanner_screen.dart';

void main() {
  group('ScannerErrorDeduplicator', () {
    test('suppresses repeated duplicate messages', () {
      final deduplicator = ScannerErrorDeduplicator();

      expect(
        deduplicator.shouldDisplay(
          'Nie udało się odczytać kodu QR. Spróbuj ponownie.',
        ),
        isTrue,
      );
      expect(
        deduplicator.shouldDisplay(
          'Nie udało się odczytać kodu QR. Spróbuj ponownie.',
        ),
        isFalse,
      );
      expect(
        deduplicator.shouldDisplay(
          'Brak dostępu do kamery. Włącz dostęp do kamery w ustawieniach urządzenia i spróbuj ponownie.',
        ),
        isTrue,
      );
    });

    test('reset clears the last reported message', () {
      final deduplicator = ScannerErrorDeduplicator();

      expect(deduplicator.shouldDisplay('foo'), isTrue);
      deduplicator.reset();
      expect(deduplicator.shouldDisplay('foo'), isTrue);
    });
  });
}
