import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/data/repositories/chats_repository_utils.dart';

void main() {
  group('communication timestamp rules', () {
    test('normalizeTransportTimestamp converts local timestamps to UTC', () {
      final local = DateTime(2024, 1, 2, 3, 4, 5, 123).toLocal();

      final normalized = normalizeTransportTimestamp(local);

      expect(normalized.isUtc, isTrue);
      expect(normalized, equals(local.toUtc()));
    });

    test(
      'parseTransportTimestamp returns null for invalid or missing values',
      () {
        expect(parseTransportTimestamp(null), isNull);
        expect(parseTransportTimestamp(''), isNull);
        expect(parseTransportTimestamp('not-a-date'), isNull);
      },
    );

    test('unknown timestamps use an explicit UTC sentinel instead of now', () {
      final sentinel = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

      expect(normalizeTransportTimestamp(null), equals(sentinel));
      expect(normalizeTransportTimestamp(null).isUtc, isTrue);
    });

    test('signal type must not silently fallback to 1', () {
      expect(normalizeSignalType(null), isNull);
      expect(normalizeSignalType(''), isNull);
      expect(normalizeSignalType('invalid'), isNull);
      expect(normalizeSignalType('2'), equals(2));
      expect(normalizeSignalType('signal'), equals(2));
      expect(normalizeSignalType('pre'), equals(3));
    });
  });
}
