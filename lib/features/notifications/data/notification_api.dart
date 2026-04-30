import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/features/notifications/domain/notification_model.dart';

class NotificationApi {
  final Dio _dio;

  NotificationApi(this._dio);

  Future<List<NotificationModel>> fetchNotifications() async {
    final response = await _dio.get(ApiEndpoints.notifications);
    final List<dynamic> data = response.data as List<dynamic>;
    return data
        .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> markAsRead(String id) async {
    await _dio.patch(ApiEndpoints.markAsRead(id));
  }

  Future<void> markAllAsRead() async {
    await _dio.patch(ApiEndpoints.markAllNotificationsAsRead);
  }

  Future<void> moveToTrash(String id) async {
    await _dio.patch(ApiEndpoints.moveToTrash(id));
  }

  Future<void> clearTrash() async {
    await _dio.delete(ApiEndpoints.clearTrash);
  }

  Future<void> restoreFromTrash(String id) async {
    await _dio.patch(ApiEndpoints.restoreFromTrash(id));
  }

  Future<void> deletePermanently(String id) async {
    await _dio.delete(ApiEndpoints.deleteNotification(id));
  }
}
