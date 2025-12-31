import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/errors/app_exception.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';

class GlobalNotificationNotifier extends Notifier<AppNotification?> {
  @override
  AppNotification? build() => null;

  // TERAZ: Przyjmuje gotowy obiekt AppNotification
  void show(AppNotification notification) {
    state = notification;

    // Reset stanu po 100ms, żeby można było pokazać ten sam komunikat ponownie
    Future.delayed(const Duration(milliseconds: 100), () => state = null);
  }

  void showFromError(Object error) {
    AppNotification notification;

    if (error is AppException) {
      notification = AppNotification(
        messageKey: error.messageKey,
        type: NotificationType.error,
      );
    } else if (error is DioException) {
      final appException = AppException.fromDio(error);
      notification = AppNotification(
        messageKey: appException.messageKey,
        type: NotificationType.error,
      );
    } else {
      notification = AppNotification(
        messageKey: 'errors.unknown',
        type: NotificationType.error,
      );
    }

    // Teraz to zadziała, bo show oczekuje obiektu
    show(notification);
  }
}

final globalNotificationProvider =
    NotifierProvider<GlobalNotificationNotifier, AppNotification?>(
      GlobalNotificationNotifier.new,
    );
