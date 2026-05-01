import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/failures/app_failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_error_provider.g.dart';

@Riverpod(keepAlive: true)
class GlobalNotification extends _$GlobalNotification {
  @override
  AppNotification? build() => null;

  void show(AppNotification notification) {
    state = notification;

    Future.microtask(() => state = null);
  }

  void showFromError(Object error, [StackTrace? stack]) {
    final failure = _mapToFailure(error);

    show(
      AppNotification(
        messageKey: failure.messageKey,
        type: NotificationType.error,
      ),
    );
  }

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
