import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/main/app_scaffold.dart';
import 'package:obywatel_plus/features/evoting/data/mock/mock_evoting_repository.dart';
import 'package:obywatel_plus/features/evoting/domain/models/voting_models.dart';

class DelegationsScreen extends StatelessWidget {
  const DelegationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScaffold(
      size: ContainerSize.medium,
      appBar: AppBar(
        title: const Text('Moje delegacje'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      child: FutureBuilder<List<Delegation>>(
        future: MockEVotingRepository.instance.getDelegations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final delegations = snapshot.data ?? const <Delegation>[];
          final delegatedToMe = delegations
              .where((d) => d.targetCitizenId == 'me' && d.isActive)
              .toList();
          final iDelegate = delegations
              .where((d) => d.sourceCitizenId == 'me' && d.isActive)
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Twoja aktualna siła głosu',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '3.0x',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text('Deleguję', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                if (iDelegate.isEmpty)
                  const Text('Nie delegujesz głosu nikomu.')
                else
                  ...iDelegate.map(
                    (d) => _DelegationTile(
                      title: d.targetName,
                      subtitle: '+ tematy: ${d.category}',
                      level: d.scope.name,
                    ),
                  ),
                const SizedBox(height: 20),
                Text('Delegują na mnie', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                if (delegatedToMe.isEmpty)
                  const Text('Brak osób, które delegowały na Ciebie głos.')
                else
                  ...delegatedToMe.map(
                    (d) => _DelegationTile(
                      title: d.sourceName,
                      subtitle: '+ poziom: ${d.scope.name}',
                      level: d.category,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DelegationTile extends StatelessWidget {
  const _DelegationTile({
    required this.title,
    required this.subtitle,
    required this.level,
  });

  final String title;
  final String subtitle;
  final String level;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
            child: Text(title.split(' ').first.substring(0, 1)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.7))),
                const SizedBox(height: 2),
                Text('Poziom: $level', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
