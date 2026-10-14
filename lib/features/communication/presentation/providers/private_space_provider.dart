import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/utils/device_info_service.dart';
import 'package:obywatel_plus/features/communication/data/datasources/private_space_api_client.dart';
import 'package:obywatel_plus/features/communication/data/dtos/private_space_item_dto.dart';
import 'package:obywatel_plus/features/communication/data/repositories/private_space_repository_impl.dart';
import 'package:obywatel_plus/features/communication/domain/repositories/private_space_repository.dart';

final privateSpaceRepositoryProvider = Provider<PrivateSpaceRepository>((ref) {
  final apiClient = ref.watch(privateSpaceApiClientProvider);
  return PrivateSpaceRepositoryImpl(apiClient);
});

class PrivateSpaceController extends AsyncNotifier<List<PrivateSpaceItemDto>> {
  late final PrivateSpaceRepository _repository;
  late final DeviceInfoService _deviceInfoService;

  @override
  FutureOr<List<PrivateSpaceItemDto>> build() async {
    _repository = ref.read(privateSpaceRepositoryProvider);
    _deviceInfoService = ref.read(deviceInfoServiceProvider);
    return _repository.listItems();
  }

  Future<void> load({int sinceVersion = 0}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => _repository.listItems(sinceVersion: sinceVersion),
    );
  }

  Future<void> refresh() => load();

  Future<void> createItem({
    required String title,
    required String content,
  }) async {
    final normalizedTitle = title.trim();
    final normalizedContent = content.trim();

    if (normalizedContent.isEmpty) {
      throw const FormatException('Treść notatki nie może być pusta.');
    }

    final deviceId = await _deviceInfoService.getOrCreateDeviceId();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.createItem(
        title: normalizedTitle.isEmpty ? 'Notatka' : normalizedTitle,
        contentType: 'text',
        encryptedPayload: normalizedContent,
        deviceId: deviceId,
      );
      return _repository.listItems();
    });
  }

  Future<void> updateItem({
    required String itemId,
    required String title,
    required String content,
  }) async {
    final normalizedTitle = title.trim();
    final normalizedContent = content.trim();

    if (normalizedContent.isEmpty) {
      throw const FormatException('Treść notatki nie może być pusta.');
    }

    final deviceId = await _deviceInfoService.getOrCreateDeviceId();
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.updateItem(
        itemId: itemId,
        title: normalizedTitle.isEmpty ? 'Notatka' : normalizedTitle,
        contentType: 'text',
        encryptedPayload: normalizedContent,
        deviceId: deviceId,
      );
      return _repository.listItems();
    });
  }

  Future<void> deleteItem(String itemId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _repository.deleteItem(itemId);
      final items = await _repository.listItems();
      return items;
    });
  }
}

final privateSpaceControllerProvider =
    AsyncNotifierProvider<PrivateSpaceController, List<PrivateSpaceItemDto>>(
  PrivateSpaceController.new,
);
