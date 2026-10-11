import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/global_notification_provider.dart';

void main() {
  group('global notification dismissal', () {
    test('dismiss removes a specific notification by id immediately', () {
      final container = ProviderContainer();
      final first = AppNotification(messageKey: 'errors.CONNECTION_ERROR');
      final second = AppNotification(messageKey: 'errors.SERVER_ERROR');

      container.read(globalNotificationProvider.notifier).show(first);
      container.read(globalNotificationProvider.notifier).show(second);

      expect(container.read(globalNotificationProvider), hasLength(2));

      container.read(globalNotificationProvider.notifier).dismiss(first.id);

      expect(container.read(globalNotificationProvider), hasLength(1));
      expect(
        container.read(globalNotificationProvider).single.id,
        second.id,
      );
    });
  });
}
