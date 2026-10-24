import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/application/e2ee_crypto_service.dart';

void main() {
  group('E2EE inbound mapping', () {
    test('resolves user/app device mapping without accepting numeric fallbacks', () {
      const userId = 'b4e3a830-9a1f-47fd-8a9d-5125d0d8c211';
      const appDeviceId = '6e90049f-ada2-435c-9bb8-73f25f432726';
      final mappings = {
        userId: {appDeviceId: 8},
      };

      final resolved = E2eeCryptoService.resolveInboundSignalDeviceId(
        senderUserId: userId,
        senderDeviceId: appDeviceId,
        mappedSignalDeviceIds: mappings,
      );

      expect(resolved, equals(8));
    });

    test('throws a mapping error when no mapping exists for the app device UUID', () {
      const userId = 'b4e3a830-9a1f-47fd-8a9d-5125d0d8c211';
      const appDeviceId = '6e90049f-ada2-435c-9bb8-73f25f432726';

      expect(
        () => E2eeCryptoService.resolveInboundSignalDeviceId(
          senderUserId: userId,
          senderDeviceId: appDeviceId,
          mappedSignalDeviceIds: const {},
        ),
        throwsA(isA<SignalDeviceMappingException>()),
      );
    });
  });
}
