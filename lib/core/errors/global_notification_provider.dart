import 'dart:async';

import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/failures/app_failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// 1. Part musi być NA KOŃCU importów
part 'global_notification_provider.g.dart';

@Riverpod(keepAlive: true)
class GlobalNotification extends _$GlobalNotification {
  @override
  List<AppNotification> build() => [];

  void show(AppNotification notification) {
    state = [...state, notification];

    final targetId = notification.id;
    Future.delayed(notification.duration, () {
      remove(targetId);
    });
  }

  /// Pokazuje błąd na podstawie obiektu Exception/Failure
  void showFromError(Object error, [StackTrace? stack]) {
    final failure = _mapToFailure(error);

    show(
      AppNotification(
        messageKey: failure.messageKey,
        type: NotificationType.error,
      ),
    );
  }

  /// Usuwa konkretne powiadomienie ze stanu
  void remove(String id) {
    state = [
      for (final n in state)
        if (n.id != id) n,
    ];
  }

  // --- PRYWATNA LOGIKA MAPOWANIA (Wewnątrz klasy!) ---

  AppFailure _mapToFailure(Object e) {
    if (e is AppFailure) return e;

    if (e is DioException) {
      return switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.connectionError => const AppFailure.network(),
        DioExceptionType.badResponse => _handleBadResponse(e),
        _ => const AppFailure.unknown(),
      };
    }

    return const AppFailure.unknown();
  }

  AppFailure _handleBadResponse(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;

    if (status != null && status >= 500) {
      return AppFailure.server(statusCode: status);
    }

    if (data is Map && data['code'] != null) {
      return AppFailure.validation(messageKey: 'errors.${data['code']}');
    }

    return const AppFailure.unknown();
  }
}
