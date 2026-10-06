import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:obywatel_plus/features/exchange/application/exchange_market_state.dart';
import 'package:obywatel_plus/features/exchange/data/mock/mock_exchange_repository.dart';
import 'package:obywatel_plus/features/exchange/domain/repositories/exchange_repository.dart';

class ExchangeMarketNotifier extends Notifier<ExchangeMarketState> {
  ExchangeRepository get _repository => MockExchangeRepository.instance;

  @override
  ExchangeMarketState build() {
    return const ExchangeMarketState(
      activeCategory: 'All',
      selectedRange: '1M',
    );
  }

  Future<void> load({String? category}) async {
    final resolvedCategory = category ?? state.activeCategory;
    final offers = await _repository.getOffers(category: resolvedCategory);
    final stats = await _repository.getMarketStats();

    state = state.copyWith(
      offers: offers,
      stats: stats,
      activeCategory: resolvedCategory,
    );
  }

  Future<void> setCategory(String category) async {
    await load(category: category);
  }

  Future<void> setRange(String range) async {
    state = state.copyWith(selectedRange: range);
  }

  Future<void> refresh() async {
    await load(category: state.activeCategory);
  }
}

final exchangeMarketProvider =
    NotifierProvider<ExchangeMarketNotifier, ExchangeMarketState>(
      ExchangeMarketNotifier.new,
    );
