import 'package:collection/collection.dart';
import 'package:obywatel_plus/features/exchange/data/models/delegation_offer.dart';
import 'package:obywatel_plus/features/exchange/data/models/market_stats.dart';
import 'package:obywatel_plus/features/exchange/domain/repositories/exchange_repository.dart';

class MockExchangeRepository implements ExchangeRepository {
  const MockExchangeRepository._();

  static const MockExchangeRepository instance = MockExchangeRepository._();

  static const List<DelegationOffer> _offers = [
    DelegationOffer(
      id: 'eco-01',
      delegateName: 'Katarzyna Zielonka',
      avatarLabel: 'KZ',
      category: 'Środowisko',
      votingPower: 1250,
      reputation: 96.8,
      historicalYield: 12.4,
      fee: 0,
      strategyDescription: 'Wsparcie dla zielonych inwestycji i efektywności energetycznej.',
      liquidityStatus: 'Aktywny',
      badge: 'Ekspert',
      activeProposals: ['Miejskie panele fotowoltaiczne', 'Ograniczenie smogu'],
      isVerified: true,
    ),
    DelegationOffer(
      id: 'trans-02',
      delegateName: 'Mateusz Krajewski',
      avatarLabel: 'MK',
      category: 'Transport',
      votingPower: 980,
      reputation: 92.1,
      historicalYield: 9.7,
      fee: 5,
      strategyDescription: 'Usprawnianie transportu publicznego oraz bezpieczniejszej mobilności.',
      liquidityStatus: 'Wysoki popyt',
      badge: 'Lokalny lider',
      activeProposals: ['Nowa linia autobusowa', 'Strefy niskiej emisji'],
      isVerified: true,
    ),
    DelegationOffer(
      id: 'budget-03',
      delegateName: 'Anna Makowska',
      avatarLabel: 'AM',
      category: 'Budżet Obywatelski',
      votingPower: 820,
      reputation: 89.5,
      historicalYield: 11.1,
      fee: 0,
      strategyDescription: 'Transparentny dobór projektów i priorytetyzacja budżetu lokalnego.',
      liquidityStatus: 'Aktywny',
      badge: 'Analityk',
      activeProposals: ['Budżet miejski', 'Rewitalizacja osiedli'],
      isVerified: false,
    ),
    DelegationOffer(
      id: 'edu-04',
      delegateName: 'Paweł Szymański',
      avatarLabel: 'PS',
      category: 'Edukacja',
      votingPower: 1540,
      reputation: 95.4,
      historicalYield: 14.9,
      fee: 0,
      strategyDescription: 'Przyspieszenie inwestycji w cyfryzację szkół i dostęp do edukacji.',
      liquidityStatus: 'Aktywny',
      badge: 'Mentor',
      activeProposals: ['Platforma e-learning', 'Grants edukacyjne'],
      isVerified: true,
    ),
    DelegationOffer(
      id: 'digital-05',
      delegateName: 'Iwona Drzewiecka',
      avatarLabel: 'ID',
      category: 'Cyfryzacja',
      votingPower: 1180,
      reputation: 93.3,
      historicalYield: 13.6,
      fee: 5,
      strategyDescription: 'Wspieranie nowoczesnej administracji i bezpiecznych usług publicznych.',
      liquidityStatus: 'Aktywny',
      badge: 'Architekt',
      activeProposals: ['Portal obywatelski', 'Cyfryzacja urzędu'],
      isVerified: true,
    ),
  ];

  @override
  Future<List<DelegationOffer>> getOffers({String? category}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (category == null || category == 'All') {
      return _offers;
    }

    return _offers
        .where((offer) => offer.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  @override
  Future<MarketStats> getMarketStats() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));

    return const MarketStats(
      totalDelegatedVolume: 468200,
      activeDelegates: 142,
      liquidityRate: 72.8,
      marketIndex: 86.4,
      trendPoints: [62.1, 64.8, 66.5, 70.3, 68.4, 74.2, 81.7, 86.4],
    );
  }

  @override
  Future<DelegationOffer?> getOfferById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _offers.firstWhereOrNull((offer) => offer.id == id);
  }
}
