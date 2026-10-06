import 'dart:async';

import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/errors/exceptions/app_exception.dart';
import 'package:obywatel_plus/core/logger/logger_provider.dart';
import 'package:obywatel_plus/core/network/network_manager.dart';
import 'package:obywatel_plus/core/network/providers.dart';
import 'package:obywatel_plus/features/auth/application/auth/auth_service.dart';
import 'package:obywatel_plus/features/auth/application/session/session_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_coordinator.g.dart';

enum SyncReadiness {
  offline,
  backendUnavailable,
  waitingForAuth,
  refreshingAuth,
  ready,
  unauthenticated,
}

extension SyncReadinessX on SyncReadiness {
  bool get isReady => this == SyncReadiness.ready;
}

@Riverpod(keepAlive: true)
class SyncCoordinator extends _$SyncCoordinator {
  Future<SyncReadiness>? _readinessFuture;

  @override
  SyncReadiness build() {
    ref.listen(networkStateProvider, (_, next) {
      final networkState = next.value ?? NetworkState.online;

      if (networkState == NetworkState.offline) {
        state = SyncReadiness.offline;
        return;
      }

      if (networkState == NetworkState.backendUnavailable) {
        state = SyncReadiness.backendUnavailable;
        return;
      }

      if (state != SyncReadiness.ready) {
        unawaited(ensureReady());
      }
    });

    final networkState = ref.read(networkStateProvider).value ?? NetworkState.online;

    if (networkState == NetworkState.offline) {
      return SyncReadiness.offline;
    }

    if (networkState == NetworkState.backendUnavailable) {
      return SyncReadiness.backendUnavailable;
    }

    return SyncReadiness.waitingForAuth;
  }

  Future<SyncReadiness> ensureReady() async {
    if (_readinessFuture != null) {
      return _readinessFuture!;
    }

    _readinessFuture = _ensureReadyInternal();

    try {
      final readiness = await _readinessFuture!;
      state = readiness;
      return readiness;
    } finally {
      _readinessFuture = null;
    }
  }

  Future<SyncReadiness> _ensureReadyInternal() async {
    final logger = ref.read(appLoggerProvider);
    final networkManager = ref.read(networkManagerProvider);

    if (networkManager.isOffline) {
      logger.d('[SYNC] Skipping synchronization: OFFLINE');
      return SyncReadiness.offline;
    }

    if (networkManager.isBackendUnavailable) {
      logger.d('[SYNC] Skipping synchronization: BACKEND_UNAVAILABLE');
      return SyncReadiness.backendUnavailable;
    }

    final sessionService = ref.read(sessionServiceProvider);
    final refreshToken = await sessionService.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      logger.w('[SYNC] Skipping synchronization: NO_REFRESH_TOKEN');
      return SyncReadiness.unauthenticated;
    }

    state = SyncReadiness.refreshingAuth;
    logger.i('[SYNC] Refreshing auth/session before sync...');

    try {
      final fresh = ref.read(authFreshProvider);
      final token = await fresh.token;

      if (token == null || token.accessToken.isEmpty) {
        logger.w('[SYNC] Auth readiness failed: no valid access token');
        return SyncReadiness.unauthenticated;
      }

      await ref.read(authServiceProvider).fetchAuthMe();
      logger.i('[SYNC] Authentication session READY');
      return SyncReadiness.ready;
    } on RevokedTokenException {
      await sessionService.clearSession();
      logger.w('[SYNC] Skipping synchronization: SESSION_REVOKED');
      return SyncReadiness.unauthenticated;
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;

      if (statusCode == 401 || statusCode == 403) {
        await sessionService.clearSession();
        logger.w('[SYNC] Skipping synchronization: SESSION_EXPIRED');
        return SyncReadiness.unauthenticated;
      }

      logger.w('[SYNC] Auth readiness failed; backend unavailable or network issue');
      return SyncReadiness.backendUnavailable;
    } catch (error, stackTrace) {
      logger.e(
        '[SYNC] Auth readiness failed',
        error: error,
        stackTrace: stackTrace,
      );
      return SyncReadiness.backendUnavailable;
    }
  }
}
