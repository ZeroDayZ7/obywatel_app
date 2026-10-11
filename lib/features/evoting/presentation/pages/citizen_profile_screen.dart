import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/theme/theme_extensions.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/features/evoting/data/mock/mock_evoting_repository.dart';
import 'package:obywatel_plus/features/evoting/domain/models/voting_models.dart';

class CitizenProfileScreen extends StatelessWidget {
  const CitizenProfileScreen({super.key, required this.citizenId});

  final String citizenId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = context.colorScheme;
    final statusColors = context.statusColors;

    return AppScaffold(
      size: ContainerSize.medium,
      appBar: AppBar(
        title: const Text('Profil obywatela'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      child: FutureBuilder<CitizenProfile?>(
        future: MockEVotingRepository.instance.getCitizenById(citizenId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = snapshot.data;
          if (profile == null) {
            return const Center(child: Text('Brak profilu obywatela'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 62,
                    backgroundColor: colorScheme.primary.withValues(alpha: 0.14),
                    child: Text(
                      profile.fullName.split(' ').map((e) => e[0]).take(2).join(),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    profile.fullName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    profile.location,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _StatTile(label: 'Głosowań', value: '${profile.votesCount}'),
                    const SizedBox(width: 12),
                    _StatTile(label: 'Frekwencja', value: '${profile.participationRate}%'),
                    const SizedBox(width: 12),
                    _StatTile(label: 'Siła głosu', value: '${profile.votingPower.toStringAsFixed(1)}x'),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Główne obszary zainteresowań', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: profile.interests
                      .map(
                        (interest) => Chip(
                          label: Text(interest),
                          backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                Text('Historia głosowań', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                ...profile.votingHistory.map(
                  (vote) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          vote.choice == VoteChoice.yes
                              ? Icons.thumb_up_alt_outlined
                              : vote.choice == VoteChoice.no
                                  ? Icons.thumb_down_alt_outlined
                                  : Icons.remove_circle_outline,
                          color: vote.choice == VoteChoice.yes
                              ? statusColors.success
                              : vote.choice == VoteChoice.no
                                  ? colorScheme.error
                                  : statusColors.warning,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(vote.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text('${vote.category} • ${vote.choice.label}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => context.push('/evoting/delegations'),
                  icon: const Icon(Icons.how_to_reg_rounded),
                  label: const Text('Deleguj głos'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(label, style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
