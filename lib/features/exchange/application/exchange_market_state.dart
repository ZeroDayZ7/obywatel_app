import 'package:obywatel_plus/features/exchange/data/models/delegation_offer.dart';
import 'package:obywatel_plus/features/exchange/data/models/market_stats.dart';

class ExchangeMarketState {
  const ExchangeMarketState({
    this.offers = const [],
    this.activeCategory = 'All',
    this.selectedRange = '1M',
    this.stats = const MarketStats(
      totalDelegatedVolume: 0,
      activeDelegates: 0,
      liquidityRate: 0,
      marketIndex: 0,
      trendPoints: [],
    ),
  });

  final List<DelegationOffer> offers;
  final String activeCategory;
  final String selectedRange;
  final MarketStats stats;

  ExchangeMarketState copyWith({
    List<DelegationOffer>? offers,
    String? activeCategory,
    String? selectedRange,
    MarketStats? stats,
  }) {
    return ExchangeMarketState(
      offers: offers ?? this.offers,
      activeCategory: activeCategory ?? this.activeCategory,
      selectedRange: selectedRange ?? this.selectedRange,
      stats: stats ?? this.stats,
    );
  }
}
