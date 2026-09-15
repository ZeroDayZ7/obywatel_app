import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/features/evoting/data/mock/mock_evoting_repository.dart';
import 'package:obywatel_plus/features/evoting/domain/models/voting_models.dart';

class MyVotesScreen extends StatelessWidget {
  const MyVotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      size: ContainerSize.medium,
      appBar: AppBar(
        title: const Text('Moje głosowania'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      child: FutureBuilder<List<Voting>>(
        future: MockEVotingRepository.instance.getMyVotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final votes = snapshot.data ?? const <Voting>[];
          if (votes.isEmpty) {
            return const Center(child: Text('Nie oddano jeszcze żadnych głosów.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: votes.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final vote = votes[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vote.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Mój wybór: ${vote.userChoice?.label ?? 'Brak'}'),
                    const SizedBox(height: 4),
                    Text('Status: ${vote.status}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
