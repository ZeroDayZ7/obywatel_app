import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/database/database.dart';

void main() {
  group('database corruption recovery policy', () {
    test('only auto-resets in debug mode when SQLite reports a corrupt database', () {
      const error = 'DatabaseException(sqlite error 26): not a database';

      expect(
        shouldAutoResetCorruptedDatabase(error, isDebugMode: true),
        isTrue,
      );
      expect(
        shouldAutoResetCorruptedDatabase(error, isDebugMode: false),
        isFalse,
      );
    });

    test('other SQLite errors do not trigger auto-reset', () {
      const error = 'DatabaseException(sqlite error 14): unable to open database file';

      expect(
        shouldAutoResetCorruptedDatabase(error, isDebugMode: true),
        isFalse,
      );
    });
  });
}
