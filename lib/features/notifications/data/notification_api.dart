import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/network/api_endpoints.dart';
import 'package:obywatel_plus/features/notifications/domain/notification_model.dart';

class NotificationApi {
  final Dio _dio;

  NotificationApi(this._dio);

  Future<List<NotificationModel>> fetchNotifications() async {
    final response = await _dio.get(ApiEndpoints.notifications);
    final List<dynamic> data = response.data;
    return data.map((json) => NotificationModel.fromJson(json)).toList();
  }

  Future<void> markAsRead(String id) async {
    await _dio.patch(ApiEndpoints.markAsRead(id));
  }

  Future<void> markAllAsRead() async {
    await _dio.patch(ApiEndpoints.markAllNotificationsAsRead);
  }
}
