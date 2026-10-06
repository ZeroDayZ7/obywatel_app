import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/core/network/clients/api_client.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/features/notifications/domain/notification_model.dart';
import 'package:obywatel_plus/features/notifications/domain/sync_batch_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_api.g.dart';

class NotificationApi {
  final ApiClient _apiClient;

  const NotificationApi(this._apiClient);

  Future<List<NotificationModel>> fetchNotifications() async {
    final response = await _apiClient.get(ApiEndpoints.notifications);
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> markAsRead(String id) async {
    await _apiClient.patch(ApiEndpoints.markAsRead(id));
  }

  Future<void> markAllAsRead() async {
    await _apiClient.patch(ApiEndpoints.markAllNotificationsAsRead);
  }

  Future<void> moveToTrash(String id) async {
    await _apiClient.patch(ApiEndpoints.moveToTrash(id));
  }

  Future<void> clearTrash() async {
    await _apiClient.delete(ApiEndpoints.clearTrash);
  }

  Future<void> restoreFromTrash(String id) async {
    await _apiClient.patch(ApiEndpoints.restoreFromTrash(id));
  }

  Future<void> deletePermanently(String id) async {
    await _apiClient.delete(ApiEndpoints.deleteNotification(id));
  }

  Future<SyncBatchResponseDto> syncBatch(List<SyncEventDto> events) async {
    final req = SyncBatchRequestDto(events: events);
    final response = await _apiClient.post(
      '${ApiEndpoints.notifications}/sync',
      data: req.toJson(),
    );
    return SyncBatchResponseDto.fromJson(response.data as Map<String, dynamic>);
  }
}

@riverpod
NotificationApi notificationApi(Ref ref) {
  return NotificationApi(ref.watch(apiClientProvider));
}
