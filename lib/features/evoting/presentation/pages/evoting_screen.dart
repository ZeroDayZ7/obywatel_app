import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/features/evoting/data/mock/mock_evoting_repository.dart';
import 'package:obywatel_plus/features/evoting/domain/models/voting_models.dart';
import 'package:obywatel_plus/features/evoting/presentation/widgets/evoting_widgets.dart';

class EVotingScreen extends StatefulWidget {
  const EVotingScreen({super.key});

  @override
  State<EVotingScreen> createState() => _EVotingScreenState();
}

class _EVotingScreenState extends State<EVotingScreen> {
  final repository = MockEVotingRepository.instance;
  late Future<List<Voting>> _votingsFuture;
  VotingCategory _selectedCategory = VotingCategory.all;
  VotingSort _selectedSort = VotingSort.endingSoonest;

  @override
  void initState() {
    super.initState();
    _reloadVotings();
  }

  void _reloadVotings() {
    _votingsFuture = repository.getVotings(
      category: _selectedCategory,
      sort: _selectedSort,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScaffold(
      size: ContainerSize.medium,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            tooltip: 'Powrót do Home',
            onPressed: () => context.go(AppRoutes.home),
          ),
          title: Text(
            'e-Voting Plus',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          actions: [
            PopupMenuButton<VotingSort>(
              icon: const Icon(Icons.tune_rounded),
              tooltip: 'Sortowanie',
              onSelected: (sort) {
                setState(() {
                  _selectedSort = sort;
                  _reloadVotings();
                });
              },
              itemBuilder: (context) => VotingSort.values
                  .map(
                    (sort) => PopupMenuItem(
                      value: sort,
                      child: Text(sort.label),
                    ),
                  )
                  .toList(),
            ),
            IconButton(
              icon: const Icon(Icons.how_to_reg_rounded),
              tooltip: 'Giełda Delegacji',
              onPressed: () => context.push(AppRoutes.eVotingExchangePath()),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      child: FutureBuilder<List<Voting>>(
        future: _votingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Błąd ładowania głosowań: ${snapshot.error}'),
            );
          }

          final votings = snapshot.data ?? const <Voting>[];

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserVotingStatsCard(theme, colorScheme),
                const SizedBox(height: 20),
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: VotingCategory.values.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = VotingCategory.values[index];
                      final isSelected = _selectedCategory == category;
                      return ChoiceChip(
                        label: Text(category.label),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            _selectedCategory = category;
                            _reloadVotings();
                          });
                        },
                        selectedColor: colorScheme.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                        backgroundColor: colorScheme.surfaceContainerHigh,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.outlineVariant.withValues(alpha: 0.5),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trwające głosowania',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.eVotingMyVotesPath()),
                      child: Text(
                        'Moje głosowania',
                        style: TextStyle(color: colorScheme.primary, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (votings.isEmpty)
                  const EmptyState(
                    title: 'Brak głosowań',
                    message: 'W tej chwili nie ma aktywnych głosowań w wybranym filtrze.',
                  )
                else
                  ...[
                    for (var i = 0; i < votings.length; i++) ...[
                      VotingCard(
                        voting: votings[i],
                        onTap: () => context.push(
                          AppRoutes.eVotingDetailPath(votings[i].id),
                        ),
                      ),
                      if (i < votings.length - 1) const SizedBox(height: 12),
                    ],
                  ],
                const SizedBox(height: 24),
                _buildLiquidDemocracyBanner(theme, colorScheme),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserVotingStatsCard(ThemeData theme, ColorScheme colorScheme) {
    return FutureBuilder<DashboardStats>(
      future: repository.getDashboardStats(),
      builder: (context, snapshot) {
        final stats = snapshot.data ??
            const DashboardStats(
              activeVotingCount: 0,
              votedCount: 0,
              delegationsCount: 0,
              currentVotingPower: 1.0,
            );

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Twój status: Aktywny wyborca',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Siła Twojego głosu: ${stats.currentVotingPower.toStringAsFixed(1)}x',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${stats.delegationsCount} aktywnych delegacji / ${stats.activeVotingCount} głosowań w toku',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${stats.votedCount}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: colorScheme.primary,
                          ),
                        ),
                        Text(
                          'Oddane głosy',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 9,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${stats.activeVotingCount} aktywnych',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLiquidDemocracyBanner(ThemeData theme, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.eVotingExchangePath()),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withValues(alpha: 0.15),
              colorScheme.secondary.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.alt_route_rounded,
                color: colorScheme.onPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Giełda delegacji',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Przejrzyj aktywne oferty, porównaj zaufanie i prześlij głos ekspertowi.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
