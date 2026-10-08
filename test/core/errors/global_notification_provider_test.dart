import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/app/lang/locale_keys.g.dart';
import 'package:obywatel_plus/core/errors/exceptions/app_exception.dart';
import 'package:obywatel_plus/core/errors/global_notification_provider.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/interceptors/global_error_interceptor.dart';
import 'package:obywatel_plus/core/network/network_manager.dart';

void main() {
  group('global error mapping', () {
    test('NetworkException maps to connectivity failure', () {
      final container = ProviderContainer();

      container
          .read(globalNotificationProvider.notifier)
          .showFromError(const NetworkException());

      final notification = container.read(globalNotificationProvider).last;

      expect(notification.messageKey, LocaleKeys.errors_CONNECTION_ERROR);
    });

    test('BackendUnavailableException maps to backend unavailable failure', () {
      final container = ProviderContainer();

      container
          .read(globalNotificationProvider.notifier)
          .showFromError(const BackendUnavailableException());

      final notification = container.read(globalNotificationProvider).last;

      expect(notification.messageKey, LocaleKeys.errors_BACKEND_UNAVAILABLE);
    });

    test('DioException with nested BackendUnavailableException keeps backend semantics', () {
      final container = ProviderContainer();

      container.read(globalNotificationProvider.notifier).showFromError(
        DioException(
          requestOptions: RequestOptions(path: '/login'),
          type: DioExceptionType.connectionError,
          error: const BackendUnavailableException(),
        ),
      );

      final notification = container.read(globalNotificationProvider).last;

      expect(notification.messageKey, LocaleKeys.errors_BACKEND_UNAVAILABLE);
    });

    test('DioException connectionError without AppException still maps to network', () {
      final container = ProviderContainer();

      container.read(globalNotificationProvider.notifier).showFromError(
        DioException(
          requestOptions: RequestOptions(path: '/login'),
          type: DioExceptionType.connectionError,
          error: const SocketException('Connection failed'),
        ),
      );

      final notification = container.read(globalNotificationProvider).last;

      expect(notification.messageKey, LocaleKeys.errors_CONNECTION_ERROR);
    });
  });

  group('network manager state', () {
    test('offline and backend unavailable states are distinct', () {
      final manager = NetworkManager();

      manager.markOffline();
      expect(manager.state, NetworkState.offline);

      manager.markBackendUnavailable();
      expect(manager.state, NetworkState.backendUnavailable);

      manager.resetAfterConnectivityRecovery();
      expect(manager.state, NetworkState.online);
    });

    test('backend unavailable state is preserved while cooldown is active', () {
      final manager = NetworkManager();

      manager.markBackendUnavailable(cooldown: const Duration(minutes: 1));

      expect(manager.isBackendUnavailable, isTrue);
      expect(manager.shouldFailFast(), isTrue);
    });
  });

  group('interceptor mapping', () {
    test('connection refused resolves to BackendUnavailableException', () {
      final manager = NetworkManager();
      final interceptor = GlobalErrorInterceptor(
        logger: AppLogger(),
        networkManager: manager,
      );

      final error = DioException(
        requestOptions: RequestOptions(path: '/login'),
        type: DioExceptionType.connectionError,
        error: const SocketException('Connection refused'),
      );

      final mapped = interceptor.mapToException(error);

      expect(interceptor.isHardBackendUnavailable(error), isTrue);
      expect(mapped, isA<BackendUnavailableException>());
    });
  });
}
