import 'package:obywatel_plus/features/exchange/data/models/delegation_offer.dart';
import 'package:obywatel_plus/features/exchange/data/models/market_stats.dart';

abstract interface class ExchangeRepository {
  Future<List<DelegationOffer>> getOffers({String? category});
  Future<MarketStats> getMarketStats();
  Future<DelegationOffer?> getOfferById(String id);
}
