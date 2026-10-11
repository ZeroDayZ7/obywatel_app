import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/app/theme/theme_extensions.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/features/evoting/data/mock/mock_evoting_repository.dart';
import 'package:obywatel_plus/features/evoting/domain/models/voting_models.dart';
import 'package:obywatel_plus/features/evoting/presentation/widgets/evoting_widgets.dart';

class VotingDetailScreen extends StatefulWidget {
  const VotingDetailScreen({super.key, required this.votingId});

  final String votingId;

  @override
  State<VotingDetailScreen> createState() => _VotingDetailScreenState();
}

class _VotingDetailScreenState extends State<VotingDetailScreen> {
  final repository = MockEVotingRepository.instance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = context.colorScheme;

    return AppScaffold(
      size: ContainerSize.medium,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Szczegóły głosowania'),
      ),
      child: FutureBuilder<Voting?>(
        future: repository.getVotingById(widget.votingId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final voting = snapshot.data;
          if (voting == null) {
            return const EmptyState(
              title: 'Nie znaleziono głosowania',
              message: 'Brak danych dla wybranego elementu.',
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    StatusPill(
                      label: voting.status,
                      color: voting.status.contains('Zakończone')
                          ? colorScheme.primaryContainer
                          : colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    StatusPill(
                      label: voting.type,
                      color: colorScheme.secondary,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  voting.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                DetailInfoRow(
                  icon: Icons.person_outline,
                  label: 'Inicjator',
                  value: voting.initiator,
                ),
                const SizedBox(height: 10),
                DetailInfoRow(
                  icon: Icons.timer_outlined,
                  label: 'Termin',
                  value: '${voting.endsAt.day}.${voting.endsAt.month}.${voting.endsAt.year}',
                ),
                const SizedBox(height: 10),
                DetailInfoRow(
                  icon: Icons.how_to_vote_outlined,
                  label: 'Uczestnicy',
                  value: '${voting.participantCount} obywateli',
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Uzasadnienie'),
                Text(
                  voting.justification,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Najważniejsze zmiany'),
                ...voting.keyChanges.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle_outline, size: 18, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Skutki'),
                ...voting.impact.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.assignment_turned_in_outlined, size: 18, color: colorScheme.secondary),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Koszty'),
                ...voting.costs.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.account_balance_wallet_outlined, size: 18, color: colorScheme.tertiary),
                        const SizedBox(width: 8),
                        Expanded(child: Text(item)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Dokument źródłowy'),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.attach_file, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Expanded(child: Text(voting.sourceDocument)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Historia zmian'),
                ...voting.history.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('• $item'),
                  ),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Argumenty ZA'),
                ...voting.argumentsFor.map(
                  (arg) => _buildArgumentTile(arg, true, colorScheme),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Argumenty PRZECIW'),
                ...voting.argumentsAgainst.map(
                  (arg) => _buildArgumentTile(arg, false, colorScheme),
                ),
                const SizedBox(height: 20),
                _buildSectionTitle('Dyskusja obywatelska'),
                ...voting.comments.map(
                  (comment) => _buildCommentTile(comment, colorScheme),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => context.push(AppRoutes.eVotingVotePath(voting.id)),
                    icon: const Icon(Icons.how_to_vote_outlined),
                    label: const Text('Głosuj'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _buildArgumentTile(VotingArgument argument, bool isFor, ColorScheme colorScheme) {
    final statusColors = context.statusColors;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isFor
              ? statusColors.success.withValues(alpha: 0.4)
              : colorScheme.error.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isFor ? Icons.thumb_up_alt_outlined : Icons.thumb_down_alt_outlined,
                size: 16,
                color: isFor ? statusColors.success : colorScheme.error,
              ),
              const SizedBox(width: 8),
              Text(
                argument.author,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text('${argument.supporters} poparcia'),
            ],
          ),
          const SizedBox(height: 8),
          Text(argument.text),
        ],
      ),
    );
  }

  Widget _buildCommentTile(CommentItem comment, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
                child: Text(comment.authorName.substring(0, 1)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  comment.authorName,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Icon(Icons.favorite_border, size: 16, color: colorScheme.primary),
              const SizedBox(width: 4),
              Text('${comment.likes}'),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment.text),
          const SizedBox(height: 8),
          Text(
            '${comment.replies} odpowiedzi',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
