import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/core/logger/app_logger.dart';

final class AppProviderObserver extends ProviderObserver {
  final AppLogger _logger;

  const AppProviderObserver(this._logger);

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    final name = _getProviderName(context);
    _logger.t('Initialized: $name', module: 'Riverpod');
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    final name = _getProviderName(context);

    // Wyłapywanie błędów asynchronicznych (np. AsyncError w FutureProvider/AsyncNotifier)
    if (newValue is AsyncValue && newValue.hasError) {
      _logger.e(
        'Async error in provider: $name',
        module: 'Riverpod',
        error: newValue.error,
        stackTrace: newValue.stackTrace,
      );
      return;
    }

    // Zwięzłe logowanie bez wielkich odstępów i nowej linii
    _logger.d(
      'Updated: $name | PREV: $previousValue -> NEXT: $newValue',
      module: 'Riverpod',
    );
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    final name = _getProviderName(context);
    _logger.e(
      'Critical failure in provider: $name',
      module: 'Riverpod',
      error: error,
      stackTrace: stackTrace,
    );
  }

  String _getProviderName(ProviderObserverContext context) {
    return context.provider.name ?? context.provider.runtimeType.toString();
  }
}