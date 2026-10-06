// lib/app/router/routes/evoting_routes.dart
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/features/evoting/presentation/pages/citizen_profile_screen.dart';
import 'package:obywatel_plus/features/evoting/presentation/pages/delegations_screen.dart';
import 'package:obywatel_plus/features/evoting/presentation/pages/evoting_screen.dart';
import 'package:obywatel_plus/features/evoting/presentation/pages/my_votes_screen.dart';
import 'package:obywatel_plus/features/evoting/presentation/pages/vote_screen.dart';
import 'package:obywatel_plus/features/evoting/presentation/pages/voting_detail_screen.dart';
import 'package:obywatel_plus/features/exchange/presentation/pages/exchange_market_screen.dart';
import 'package:obywatel_plus/features/exchange/presentation/pages/offer_details_screen.dart';

final eVotingRoutes = [
  GoRoute(
    path: AppRoutes.eVoting,
    builder: (context, state) => const EVotingScreen(),
    routes: [
      GoRoute(
        path: 'detail/:id',
        builder: (context, state) {
          final votingId = state.pathParameters['id'] ?? '';
          return VotingDetailScreen(votingId: votingId);
        },
      ),
      GoRoute(
        path: 'vote/:id',
        builder: (context, state) {
          final votingId = state.pathParameters['id'] ?? '';
          return VoteScreen(votingId: votingId);
        },
      ),
      GoRoute(
        path: 'citizen/:citizenId',
        builder: (context, state) {
          final citizenId = state.pathParameters['citizenId'] ?? '';
          return CitizenProfileScreen(citizenId: citizenId);
        },
      ),
      GoRoute(
        path: 'delegations',
        builder: (context, state) => const DelegationsScreen(),
      ),
      GoRoute(
        path: 'my-votes',
        builder: (context, state) => const MyVotesScreen(),
      ),
      GoRoute(
        path: 'exchange',
        builder: (context, state) => const ExchangeMarketScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final offerId = state.pathParameters['id'] ?? '';
              return OfferDetailsScreen(offerId: offerId);
            },
          ),
        ],
      ),
    ],
  ),
];