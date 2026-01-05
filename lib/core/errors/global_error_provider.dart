import 'package:dio/dio.dart';
import 'package:obywatel_plus/core/errors/app_notification.dart';
import 'package:obywatel_plus/core/errors/failures/app_failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_error_provider.g.dart';

@riverpod
class GlobalNotification extends _$GlobalNotification {
  @override
  AppNotification? build() => null;

  /// Wyświetla dowolną notyfikację (Success, Info, Error)
  void show(AppNotification notification) {
    state = notification;
    
    // Używamy mikro-zadania zamiast 100ms, aby zresetować stan natychmiast
    // po tym, jak Listener w UI go przechwyci.
    Future.microtask(() => state = null);
  }

  /// Wyświetla notyfikację błędu na podstawie dowolnego obiektu błędu
  void showFromError(Object error, [StackTrace? stack]) {
    final failure = _mapToFailure(error);
    
    show(AppNotification(
      messageKey: failure.messageKey,
      type: NotificationType.error,
    ));
  }

  /// Centralna logika mapowania błędów (zastępuje AppException.fromDio)
  AppFailure _mapToFailure(Object e) {
    if (e is AppFailure) return e;

    if (e is DioException) {
      return switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.connectionError =>
          const AppFailure.network(),
          
        DioExceptionType.badResponse => _handleBadResponse(e),
        
        _ => const AppFailure.unknown(),
      };
    }

    return const AppFailure.unknown();
  }

  /// Prywatna metoda do obsługi błędów 4xx i 5xx
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