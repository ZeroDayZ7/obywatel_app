import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

final class AppObserver extends ProviderObserver {
  const AppObserver(this._logger);

  final AppLogger _logger;

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    final name = context.provider.name ?? context.provider.runtimeType;

    if (newValue is AsyncValue && newValue.hasError) {
      _logger.e(
        'Async Error w providerze: $name',
        module: 'Riverpod',
        error: newValue.error,
        stackTrace: newValue.stackTrace,
      );
      return;
    }

    _logger.d('Provider $name zmienił stan', module: 'Riverpod');
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    final name = context.provider.name ?? context.provider.runtimeType;

    _logger.e(
      'Krytyczny błąd providera: $name',
      module: 'Riverpod',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
