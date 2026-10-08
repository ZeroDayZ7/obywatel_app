import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';
import 'package:obywatel_plus/features/home/application/quick_access_notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('QuickAccessNotifier', () {
    test('loads default items when there are no persisted entries', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [
          activePrefsProvider.overrideWithValue(
            SharedPreferencesService(prefs, AppLogger()),
          ),
        ],
      );

      final items = container.read(quickAccessProvider);

      expect(items, isNotEmpty);
      expect(items.every((item) => item.isEnabled || item.id.isNotEmpty), isTrue);
    });

    test('toggleEnabled updates state and persists the change', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [
          activePrefsProvider.overrideWithValue(
            SharedPreferencesService(prefs, AppLogger()),
          ),
        ],
      );

      final firstId = container.read(quickAccessProvider).first.id;

      await container.read(quickAccessProvider.notifier).toggleEnabled(firstId);

      final updated = container.read(quickAccessProvider);
      final item = updated.firstWhere((entry) => entry.id == firstId);

      expect(item.isEnabled, isFalse);
      expect(prefs.getString('home.quick_access.items'), isNotNull);
    });
  });
}
