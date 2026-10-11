import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/core/errors/exceptions/app_exception.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';
import 'package:obywatel_plus/core/network/interceptors/global_error_interceptor.dart';
import 'package:obywatel_plus/core/network/network_manager.dart';

void main() {
  group('NetworkManager', () {
    test('marks backend unavailable and blocks requests during cooldown', () {
      final manager = NetworkManager(
        connectivity: ConnectivityAdapter(Connectivity()),
        clock: () => DateTime(2024, 1, 1, 12, 0, 0),
      );

      manager.markBackendUnavailable(cooldown: const Duration(seconds: 30));

      expect(manager.state, NetworkState.backendUnavailable);
      expect(manager.shouldFailFast(), isTrue);
    });

    test('clears backend downtime when connectivity recovers', () {
      final manager = NetworkManager(
        connectivity: ConnectivityAdapter(Connectivity()),
        clock: () => DateTime(2024, 1, 1, 12, 0, 0),
      );

      manager.markBackendUnavailable(cooldown: const Duration(seconds: 30));
      manager.resetAfterConnectivityRecovery();

      expect(manager.state, NetworkState.online);
      expect(manager.shouldFailFast(), isFalse);
    });

    test('offline is distinct from backend unavailable', () {
      final manager = NetworkManager(
        connectivity: ConnectivityAdapter(Connectivity()),
        clock: () => DateTime(2024, 1, 1, 12, 0, 0),
      );

      manager.markOffline();

      expect(manager.state, NetworkState.offline);
      expect(manager.shouldFailFast(), isTrue);
      expect(manager.isBackendUnavailable, isFalse);
    });

    test('all consumers share the same global manager instance', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final managerA = container.read(networkManagerProvider);
      final managerB = container.read(networkManagerProvider);

      expect(identical(managerA, managerB), isTrue);
      expect(managerA.state, NetworkState.unknown);
    });

    test('connection refused is hard backend unavailable and no retry', () {
      final manager = NetworkManager(
        connectivity: ConnectivityAdapter(Connectivity()),
        clock: () => DateTime(2024, 1, 1, 12, 0, 0),
      );
      final interceptor = GlobalErrorInterceptor(
        logger: AppLogger(),
        networkManager: manager,
      );

      final err = DioException(
        requestOptions: RequestOptions(path: '/auth/me'),
        type: DioExceptionType.connectionError,
        error: SocketException(
          'Komputer zdalny odrzucił połączenie sieciowe',
          address: InternetAddress.loopbackIPv4,
          port: 8080,
          osError: const OSError('Komputer zdalny odrzucił połączenie sieciowe', 1225),
        ),
      );

      final mapped = interceptor.mapToException(err);
      expect(mapped, isA<BackendUnavailableException>());
      expect(interceptor.shouldRetry(err), isFalse);
      expect(interceptor.shouldOpenCircuitImmediately(err), isTrue);
      expect(manager.shouldFailFast(), isFalse);
    });

    test('connection refused opens circuit breaker immediately without retry', () async {
      final manager = NetworkManager(
        connectivity: ConnectivityAdapter(Connectivity()),
        clock: () => DateTime(2024, 1, 1, 12, 0, 0),
      );
      final interceptor = GlobalErrorInterceptor(
        logger: AppLogger(),
        networkManager: manager,
      );
      final requestOptions = RequestOptions(path: '/auth/me', extra: <String, dynamic>{});
      final err = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionError,
        error: const SocketException('Connection refused'),
      );

      expect(interceptor.shouldOpenCircuitImmediately(err), isTrue);
      expect(interceptor.mapToException(err), isA<BackendUnavailableException>());
      expect(interceptor.shouldRetry(err), isFalse);
      expect(manager.shouldFailFast(), isFalse);
    });

    test('timeout remains retryable', () {
      final manager = NetworkManager(
        connectivity: ConnectivityAdapter(Connectivity()),
        clock: () => DateTime(2024, 1, 1, 12, 0, 0),
      );
      final interceptor = GlobalErrorInterceptor(
        logger: AppLogger(),
        networkManager: manager,
      );

      final err = DioException(
        requestOptions: RequestOptions(path: '/auth/me'),
        type: DioExceptionType.receiveTimeout,
        error: const TimeoutException(),
      );

      expect(interceptor.mapToException(err), isA<TimeoutException>());
      expect(interceptor.shouldRetry(err), isTrue);
    });

    test('offline blocks HTTP request before it is sent', () async {
      final manager = NetworkManager(
        connectivity: ConnectivityAdapter(Connectivity()),
        clock: () => DateTime(2024, 1, 1, 12, 0, 0),
      );
      manager.markOffline();
      final interceptor = GlobalErrorInterceptor(
        logger: AppLogger(),
        networkManager: manager,
      );
      final options = RequestOptions(path: '/auth/me');

      expect(manager.shouldFailFast(), isTrue);
      expect(interceptor.mapToException(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          error: const NetworkException(),
        ),
      ), isA<NetworkException>());
    });

    test('http auth and forbidden and not found errors are not retryable transport errors', () {
      final manager = NetworkManager(
        connectivity: ConnectivityAdapter(Connectivity()),
        clock: () => DateTime(2024, 1, 1, 12, 0, 0),
      );
      final interceptor = GlobalErrorInterceptor(
        logger: AppLogger(),
        networkManager: manager,
      );

      final unauthorized = DioException(
        requestOptions: RequestOptions(path: '/auth/me'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/me'),
          statusCode: 401,
        ),
      );
      final forbidden = DioException(
        requestOptions: RequestOptions(path: '/auth/me'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/me'),
          statusCode: 403,
        ),
      );
      final notFound = DioException(
        requestOptions: RequestOptions(path: '/auth/me'),
        response: Response(
          requestOptions: RequestOptions(path: '/auth/me'),
          statusCode: 404,
        ),
      );

      expect(interceptor.mapToException(unauthorized), isA<UnauthorizedException>());
      expect(interceptor.shouldRetry(unauthorized), isFalse);
      expect(interceptor.mapToException(forbidden), isA<ForbiddenException>());
      expect(interceptor.shouldRetry(forbidden), isFalse);
      expect(interceptor.mapToException(notFound), isA<UnknownException>());
      expect(interceptor.shouldRetry(notFound), isFalse);
    });
  });
}
