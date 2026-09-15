import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/features/evoting/data/mock/mock_evoting_repository.dart';
import 'package:obywatel_plus/features/evoting/domain/models/voting_models.dart';

class VoteScreen extends StatefulWidget {
  const VoteScreen({super.key, required this.votingId});

  final String votingId;

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  final repository = MockEVotingRepository.instance;
  VoteChoice? _selectedChoice;
  bool _confirmed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScaffold(
      size: ContainerSize.medium,
      appBar: AppBar(
        title: const Text('Głosowanie'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      child: FutureBuilder<Voting?>(
        future: repository.getVotingById(widget.votingId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final voting = snapshot.data;
          if (voting == null) {
            return const Center(child: Text('Brak danych głosowania'));
          }

          if (_confirmed) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_rounded, size: 64, color: Colors.green),
                    const SizedBox(height: 16),
                    Text(
                      'Twój głos został zapisany',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Wybrano: ${_selectedChoice!.label}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        context.pop();
                        context.pop();
                      },
                      child: const Text('Wróć do głosowania'),
                    ),
                  ],
                ),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  voting.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Waga głosu: 1.0x',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Typ: ${voting.type} • ${voting.scope.name}',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                ...VoteChoice.values.map(
                  (choice) => Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: _selectedChoice == choice
                            ? colorScheme.primary
                            : colorScheme.surfaceContainerHighest,
                        foregroundColor: _selectedChoice == choice
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
                      ),
                      onPressed: () {
                        setState(() => _selectedChoice = choice);
                      },
                      child: Text(choice.label),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_selectedChoice != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Podsumowanie',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Głos: ${_selectedChoice!.label}'),
                        const SizedBox(height: 4),
                        Text('Waga głosu: 1.0x'),
                        const SizedBox(height: 4),
                        Text(
                          'Źródło: ${voting.userDelegated ? 'delegacja' : 'własny głos'}',
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _selectedChoice == null
                      ? null
                      : () async {
                          await repository.castVote(
                            widget.votingId,
                            _selectedChoice!,
                            delegated: voting.userDelegated,
                          );
                          setState(() => _confirmed = true);
                        },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Potwierdź głos'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
