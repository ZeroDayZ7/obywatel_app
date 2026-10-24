import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/application/e2ee_crypto_service.dart';
import 'package:uuid/uuid.dart';

void main() {
  const senderUserId = 'user-123';

  test('resolves a valid appDeviceId mapping to a single Signal device id', () {
    final appDeviceId = const Uuid().v4();
    final mappings = E2eeCryptoService.setSignalDeviceMapping(
      senderUserId: senderUserId,
      appDeviceId: appDeviceId,
      signalDeviceId: 7,
    );

    final resolvedDeviceId = E2eeCryptoService.resolveInboundSignalDeviceId(
      senderUserId: senderUserId,
      senderDeviceId: appDeviceId,
      mappedSignalDeviceIds: mappings,
    );

    expect(resolvedDeviceId, 7);
  });

  test('rejects UUID without an explicit mapping', () {
    final appDeviceId = const Uuid().v4();

    expect(
      () => E2eeCryptoService.resolveInboundSignalDeviceId(
        senderUserId: senderUserId,
        senderDeviceId: appDeviceId,
        mappedSignalDeviceIds: const <String, Map<String, int>>{},
      ),
      throwsA(isA<SignalDeviceMappingException>()),
    );
  });

  test(
    'rejects numeric senderDeviceId values instead of treating them as Signal ids',
    () {
      final appDeviceId = const Uuid().v4();
      final mappings = E2eeCryptoService.setSignalDeviceMapping(
        senderUserId: senderUserId,
        appDeviceId: appDeviceId,
        signalDeviceId: 7,
      );

      expect(
        () => E2eeCryptoService.resolveInboundSignalDeviceId(
          senderUserId: senderUserId,
          senderDeviceId: '7',
          mappedSignalDeviceIds: mappings,
        ),
        throwsA(isA<FormatException>()),
      );
    },
  );

  test('rejects conflicting mappings for the same appDeviceId', () {
    final appDeviceId = const Uuid().v4();
    final existingMappings = <String, Map<String, int>>{
      senderUserId: {appDeviceId: 7},
    };

    expect(
      () => E2eeCryptoService.setSignalDeviceMapping(
        senderUserId: senderUserId,
        appDeviceId: appDeviceId,
        signalDeviceId: 9,
        existingMappings: existingMappings,
      ),
      throwsA(isA<SignalDeviceMappingConflictException>()),
    );
  });

  test(
    'accepts only the mapped Signal device and rejects other session candidates',
    () {
      final appDeviceIdA = const Uuid().v4();
      final appDeviceIdB = const Uuid().v4();
      final mappings = E2eeCryptoService.setSignalDeviceMapping(
        senderUserId: senderUserId,
        appDeviceId: appDeviceIdA,
        signalDeviceId: 7,
        existingMappings: {
          senderUserId: {appDeviceIdB: 3},
        },
      );

      final resolvedDeviceId = E2eeCryptoService.resolveInboundSignalDeviceId(
        senderUserId: senderUserId,
        senderDeviceId: appDeviceIdA,
        mappedSignalDeviceIds: mappings,
      );

      expect(resolvedDeviceId, 7);
      expect(resolvedDeviceId, isNot(3));
    },
  );

  test(
    'rejects invalid Signal device ids instead of guessing or coercing them',
    () {
      expect(
        () => E2eeCryptoService.resolveSignalDeviceId('invalid-device-id'),
        throwsA(isA<FormatException>()),
      );

      expect(
        () => E2eeCryptoService.resolveSignalDeviceId('0'),
        throwsA(isA<FormatException>()),
      );
    },
  );

  test('keeps multiple app devices for the same user separate', () {
    final appDeviceIdA = const Uuid().v4();
    final appDeviceIdB = const Uuid().v4();

    final mappings = E2eeCryptoService.setSignalDeviceMapping(
      senderUserId: senderUserId,
      appDeviceId: appDeviceIdA,
      signalDeviceId: 7,
    );
    final mergedMappings = E2eeCryptoService.setSignalDeviceMapping(
      senderUserId: senderUserId,
      appDeviceId: appDeviceIdB,
      signalDeviceId: 11,
      existingMappings: mappings,
    );

    expect(
      E2eeCryptoService.resolveInboundSignalDeviceId(
        senderUserId: senderUserId,
        senderDeviceId: appDeviceIdA,
        mappedSignalDeviceIds: mergedMappings,
      ),
      7,
    );
    expect(
      E2eeCryptoService.resolveInboundSignalDeviceId(
        senderUserId: senderUserId,
        senderDeviceId: appDeviceIdB,
        mappedSignalDeviceIds: mergedMappings,
      ),
      11,
    );
  });

  test('keeps the mapping stable across object copies', () {
    final appDeviceId = const Uuid().v4();
    final persistedMappings = E2eeCryptoService.setSignalDeviceMapping(
      senderUserId: senderUserId,
      appDeviceId: appDeviceId,
      signalDeviceId: 13,
    );

    final restoredMappings = <String, Map<String, int>>{
      for (final entry in persistedMappings.entries)
        entry.key: Map<String, int>.from(entry.value),
    };

    expect(
      E2eeCryptoService.resolveInboundSignalDeviceId(
        senderUserId: senderUserId,
        senderDeviceId: appDeviceId,
        mappedSignalDeviceIds: restoredMappings,
      ),
      13,
    );
  });
}
