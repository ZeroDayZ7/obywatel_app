// lib/core/errors/global_error_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';

class GlobalNotificationNotifier extends Notifier<AppNotification?> {
  @override
  AppNotification? build() => null;

  void show(
    String messageKey, {
    NotificationType type = NotificationType.error,
  }) {
    state = AppNotification(messageKey: messageKey, type: type);

    // Szybki reset, aby umożliwić ponowne wywołanie tego samego błędu
    Future.delayed(const Duration(milliseconds: 100), () => state = null);
  }
}

final globalNotificationProvider =
    NotifierProvider<GlobalNotificationNotifier, AppNotification?>(
      GlobalNotificationNotifier.new,
    );
