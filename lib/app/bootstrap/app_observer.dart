import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class AppObserver extends ProviderObserver {
  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    debugPrint(
      '🟢 Dodano provider: ${context.provider.name ?? context.provider.runtimeType}',
    );
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    debugPrint(
      '🔄 Zmieniono provider: ${context.provider.name ?? context.provider.runtimeType}',
    );
    debugPrint('   ze: $previousValue na: $newValue');
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    debugPrint(
      '❌ Usunięto provider: ${context.provider.name ?? context.provider.runtimeType}',
    );
  }
}
