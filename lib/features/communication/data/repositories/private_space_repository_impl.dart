import 'package:obywatel_plus/features/communication/data/datasources/private_space_api_client.dart';
import 'package:obywatel_plus/features/communication/data/dtos/private_space_item_dto.dart';
import 'package:obywatel_plus/features/communication/domain/repositories/private_space_repository.dart';

class PrivateSpaceRepositoryImpl implements PrivateSpaceRepository {
  const PrivateSpaceRepositoryImpl(this._apiClient);

  final PrivateSpaceApiClient _apiClient;

  @override
  Future<List<PrivateSpaceItemDto>> listItems({int sinceVersion = 0}) {
    return _apiClient.listItems(sinceVersion: sinceVersion);
  }

  @override
  Future<PrivateSpaceItemDto> createItem({
    required String title,
    required String contentType,
    required String encryptedPayload,
    required String deviceId,
  }) {
    return _apiClient.createItem(
      title: title,
      contentType: contentType,
      encryptedPayload: encryptedPayload,
      deviceId: deviceId,
    );
  }

  @override
  Future<PrivateSpaceItemDto> updateItem({
    required String itemId,
    String? title,
    String? contentType,
    String? encryptedPayload,
    String? deviceId,
    int? syncVersion,
  }) {
    return _apiClient.updateItem(
      itemId: itemId,
      title: title,
      contentType: contentType,
      encryptedPayload: encryptedPayload,
      deviceId: deviceId,
      syncVersion: syncVersion,
    );
  }

  @override
  Future<void> deleteItem(String itemId) {
    return _apiClient.deleteItem(itemId);
  }
}
