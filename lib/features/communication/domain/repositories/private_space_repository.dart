import 'package:obywatel_plus/features/communication/data/dtos/private_space_item_dto.dart';

abstract class PrivateSpaceRepository {
  Future<List<PrivateSpaceItemDto>> listItems({int sinceVersion = 0});

  Future<PrivateSpaceItemDto> createItem({
    required String title,
    required String contentType,
    required String encryptedPayload,
    required String deviceId,
  });

  Future<PrivateSpaceItemDto> updateItem({
    required String itemId,
    String? title,
    String? contentType,
    String? encryptedPayload,
    String? deviceId,
    int? syncVersion,
  });

  Future<void> deleteItem(String itemId);
}
