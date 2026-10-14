import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/communication/data/dtos/private_space_item_dto.dart';

void main() {
  group('PrivateSpaceItemDto contract', () {
    test('uses camelCase JSON keys and preserves content', () {
      final json = {
        'id': 'a8b5d25a-4e2e-4a47-bd6d-12f4e1d5fb50',
        'spaceId': 'c0f665f5-2e65-4327-a92d-90a9d90fa6b4',
        'ownerId': 'd94ff2ed-30b8-4507-ae72-d262b5494c98',
        'deviceId': 'device-1',
        'title': 'Moja notatka',
        'contentType': 'text',
        'encryptedPayload': 'Y2lwaGVydGV4dA==',
        'syncVersion': 3,
        'createdAt': '2026-10-14T12:00:00Z',
        'updatedAt': '2026-10-14T12:05:00Z',
        'status': 'active',
      };

      final dto = PrivateSpaceItemDto.fromJson(json);
      expect(dto.spaceId, 'c0f665f5-2e65-4327-a92d-90a9d90fa6b4');
      expect(dto.ownerId, 'd94ff2ed-30b8-4507-ae72-d262b5494c98');
      expect(dto.deviceId, 'device-1');
      expect(dto.contentType, 'text');
      expect(dto.syncVersion, 3);
      expect(dto.toJson()['encryptedPayload'], 'Y2lwaGVydGV4dA==');
      expect(dto.toJson().containsKey('space_id'), isFalse);
      expect(dto.toJson().containsKey('owner_id'), isFalse);
      expect(dto.toJson().containsKey('encrypted_payload'), isFalse);
    });
  });
}
