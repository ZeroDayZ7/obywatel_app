import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:obywatel_plus/features/communication/presentation/widgets/contacts_screen/qr_scanner_screen.dart';

void main() {
  testWidgets(
    'onDetectError deduplicates repeated scan errors and errorBuilder renders permission guidance',
    (tester) async {
      await tester.pumpWidget(const MaterialApp(home: QrScannerScreen()));

      final scanner = tester.widget<MobileScanner>(find.byType(MobileScanner));
      final onDetectError = scanner.onDetectError;
      final errorBuilder = scanner.errorBuilder;

      expect(onDetectError, isNotNull);
      expect(errorBuilder, isNotNull);

      const genericError = MobileScannerException(
        errorCode: MobileScannerErrorCode.genericError,
      );
      const permissionError = MobileScannerException(
        errorCode: MobileScannerErrorCode.permissionDenied,
      );

      onDetectError(genericError, StackTrace.current);
      await tester.pump();
      expect(tester.widgetList<SnackBar>(find.byType(SnackBar)).length, 1);

      onDetectError(genericError, StackTrace.current);
      await tester.pump();
      expect(tester.widgetList<SnackBar>(find.byType(SnackBar)).length, 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => errorBuilder!(context, permissionError),
          ),
        ),
      );

      expect(
        find.text(
          'Brak dostępu do kamery. Włącz dostęp do kamery w ustawieniach urządzenia i spróbuj ponownie.',
        ),
        findsOneWidget,
      );
    },
  );
}
