import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/home/application/quick_access_notifier.dart';

void main() {
  group('QuickAccessNotifier', () {
    test('always loads the static default menu from code', () {
      final container = ProviderContainer();

      final items = container.read(quickAccessProvider);

      expect(items, isNotEmpty);
      expect(items.length, 3);
      expect(items.every((item) => item.isEnabled), isTrue);
      expect(items.map((item) => item.id), containsAll(['communication', 'evoting', 'market']));
    });
  });
}
