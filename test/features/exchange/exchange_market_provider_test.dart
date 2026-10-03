import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obywatel_plus/features/exchange/application/exchange_market_provider.dart';

void main() {
  test('exchange market provider loads mock data', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(exchangeMarketProvider.notifier);
    await notifier.load();
    final state = container.read(exchangeMarketProvider);

    expect(state.offers, isNotEmpty);
    expect(state.stats.totalDelegatedVolume > 0, isTrue);
    expect(state.activeCategory, 'All');
  });
}
