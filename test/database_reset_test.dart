import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/app/bootstrap/logic/tasks.dart';
import 'package:obywatel_plus/core/database/database.dart';
import 'package:obywatel_plus/core/database/database_provider.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/storage/secure_storage_provider.dart';
import 'package:obywatel_plus/core/storage/shared_preferences_provider.dart';
import 'package:obywatel_plus/core/storage/storage_keys.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async {
            if (call.method == 'getApplicationDocumentsDirectory') {
              return Directory.systemTemp.path;
            }
            return null;
          },
        );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          null,
        );
  });

  test(
    'active reset deletes encrypted database files and storage key',
    () async {
      final dbDir = await getApplicationDocumentsDirectory();
      final dbPath = p.join(dbDir.path, 'obywatel_plus_encrypted.sqlite');

      for (final suffix in ['', '-wal', '-shm', '-journal']) {
        await File('$dbPath$suffix').writeAsString('stale-data');
      }

      final storage = SecureStorageService(
        const FlutterSecureStorage(),
        AppLogger(),
      );
      final prefs = SharedPreferencesService(
        await SharedPreferences.getInstance(),
        AppLogger(),
      );

      await storage.write(key: StorageKeys.databaseKey, value: 'abc123');
      await prefs.write('dev_test_flag', 'value');

      await StorageInitTask(
        storage: storage,
        prefs: prefs,
        developerResetEnabled: true,
        databaseBuilder: () =>
            throw StateError('database should not open during reset'),
      ).initialize();

      expect(await storage.read(key: StorageKeys.databaseKey), isNull);
      expect(prefs.read('dev_test_flag'), isNull);

      for (final suffix in ['', '-wal', '-shm', '-journal']) {
        expect(
          File('$dbPath$suffix').existsSync(),
          isFalse,
          reason: 'Database sidecar should be removed during reset',
        );
      }
    },
  );

  test('disabled reset keeps data untouched', () async {
    final dbDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbDir.path, 'obywatel_plus_encrypted.sqlite');

    final storage = SecureStorageService(
      const FlutterSecureStorage(),
      AppLogger(),
    );
    final prefs = SharedPreferencesService(
      await SharedPreferences.getInstance(),
      AppLogger(),
    );

    await storage.write(key: StorageKeys.databaseKey, value: 'keep-me');
    await prefs.write('dev_test_flag', 'value');
    await File(dbPath).writeAsString('keep');

    await StorageInitTask(
      storage: storage,
      prefs: prefs,
      developerResetEnabled: false,
      databaseBuilder: () =>
          throw StateError('database should not open during reset'),
    ).initialize();

    expect(await storage.read(key: StorageKeys.databaseKey), 'keep-me');
    expect(prefs.read('dev_test_flag'), 'value');
    expect(File(dbPath).existsSync(), isTrue);
  });

  test('reset is debug-mode gated', () {
    expect(
      shouldResetLocalDataForDevelopment(
        isDebugMode: true,
        developerResetEnabled: true,
      ),
      isTrue,
    );
    expect(
      shouldResetLocalDataForDevelopment(
        isDebugMode: true,
        developerResetEnabled: false,
      ),
      isFalse,
    );
    expect(
      shouldResetLocalDataForDevelopment(
        isDebugMode: false,
        developerResetEnabled: true,
      ),
      isFalse,
    );
    expect(kDebugMode, isTrue);
  });

  test('reset does not open the database before cleanup', () async {
    final storage = SecureStorageService(
      const FlutterSecureStorage(),
      AppLogger(),
    );
    final prefs = SharedPreferencesService(
      await SharedPreferences.getInstance(),
      AppLogger(),
    );

    final task = StorageInitTask(
      storage: storage,
      prefs: prefs,
      developerResetEnabled: true,
      databaseBuilder: () {
        throw StateError('databaseBuilder should not run during reset');
      },
    );

    await task.initialize();
  });

  test('DatabaseKeyCodec creates a valid 32-byte key for a fresh DB', () async {
    final keyBytes = List<int>.generate(32, (index) => index + 1);
    final encodedKey = DatabaseKeyCodec.encodeKeyBytes(keyBytes);

    expect(encodedKey.length, 64);
    expect(DatabaseKeyCodec.decodeHexKey(encodedKey), keyBytes);

    final database = AppDatabase(openConnection(encodedKey));
    addTearDown(() async => database.close());

    final result = await database.customSelect('SELECT 1 AS answer;').get();
    expect(result.first.data['answer'], 1);
  });
}
