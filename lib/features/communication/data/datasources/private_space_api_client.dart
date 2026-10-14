import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/features/communication/data/dtos/private_space_item_dto.dart';

class PrivateSpaceApiClient {
  const PrivateSpaceApiClient(this._apiClient);

  final ApiClient _apiClient;

  Future<List<PrivateSpaceItemDto>> listItems({int sinceVersion = 0}) async {
    final response = await _apiClient.get(
      '/personal-space/items',
      queryParams: {'sinceVersion': sinceVersion},
    );

    final payload = response.data as Map<String, dynamic>? ?? const {};
    final items = payload['items'] as List<dynamic>? ?? const <dynamic>[];
    return items
        .map(
          (entry) => PrivateSpaceItemDto.fromJson(
            Map<String, dynamic>.from(entry as Map),
          ),
        )
        .toList();
  }

  Future<PrivateSpaceItemDto> createItem({
    required String title,
    required String contentType,
    required String encryptedPayload,
    required String deviceId,
  }) async {
    final response = await _apiClient.post(
      '/personal-space/items',
      data: {
        'title': title,
        'contentType': contentType,
        'deviceId': deviceId,
        'encryptedPayload': encryptedPayload,
      },
    );

    final payload = response.data as Map<String, dynamic>? ?? const {};
    return PrivateSpaceItemDto.fromJson(payload);
  }

  Future<PrivateSpaceItemDto> updateItem({
    required String itemId,
    String? title,
    String? contentType,
    String? encryptedPayload,
    String? deviceId,
    int? syncVersion,
  }) async {
    final data = <String, dynamic>{};
    if (title != null) {
      data['title'] = title;
    }
    if (contentType != null) {
      data['contentType'] = contentType;
    }
    if (encryptedPayload != null) {
      data['encryptedPayload'] = encryptedPayload;
    }
    if (deviceId != null) {
      data['deviceId'] = deviceId;
    }
    if (syncVersion != null) {
      data['syncVersion'] = syncVersion;
    }

    final response = await _apiClient.put(
      '/personal-space/items/$itemId',
      data: data,
    );

    final payload = response.data as Map<String, dynamic>? ?? const {};
    return PrivateSpaceItemDto.fromJson(payload);
  }

  Future<void> deleteItem(String itemId) async {
    await _apiClient.delete('/personal-space/items/$itemId');
  }
}

final privateSpaceApiClientProvider = Provider<PrivateSpaceApiClient>((ref) {
  return PrivateSpaceApiClient(ref.watch(apiClientProvider));
});
