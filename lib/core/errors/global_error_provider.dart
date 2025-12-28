import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/app_exception.dart';

class GlobalNotificationNotifier extends Notifier<AppNotification?> {
  @override
  AppNotification? build() => null;

  void show(
    String messageKey, {
    NotificationType type = NotificationType.error,
    Map<String, String>? namedArgs,
  }) {
    state = AppNotification(
      messageKey: messageKey,
      type: type,
      namedArgs: namedArgs,
    );

    // Reset stanu po 100ms, żeby można było pokazać ten sam komunikat ponownie
    Future.delayed(const Duration(milliseconds: 100), () => state = null);
  }

  void showFromError(Object error) {
    if (error is AppException) {
      show(error.messageKey, type: NotificationType.error);
    } else if (error is DioException) {
      show('errors.network', type: NotificationType.error);
    } else {
      show('errors.unknown', type: NotificationType.error);
    }
  }
}

final globalNotificationProvider =
    NotifierProvider<GlobalNotificationNotifier, AppNotification?>(
      GlobalNotificationNotifier.new,
    );
