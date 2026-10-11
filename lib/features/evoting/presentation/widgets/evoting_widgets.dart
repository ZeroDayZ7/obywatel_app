import 'package:flutter/material.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/features/evoting/domain/models/voting_models.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    required this.color,
    this.textColor,
  });

  final String label;
  final Color color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final surfaceText = textColor ?? Theme.of(context).colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: surfaceText,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class VotingCard extends StatelessWidget {
  const VotingCard({
    super.key,
    required this.voting,
    required this.onTap,
  });

  final Voting voting;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final urgent = voting.endsAt.difference(DateTime.now()).inDays <= 2;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: urgent
              ? colorScheme.error.withValues(alpha: 0.45)
              : colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: urgent ? 1.5 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: voting.scope == VotingScope.local
                            ? colorScheme.primary.withValues(alpha: 0.12)
                            : voting.scope == VotingScope.regional
                                ? colorScheme.tertiary.withValues(alpha: 0.12)
                                : colorScheme.secondary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${voting.scope.name.toUpperCase()} • ${voting.type}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: voting.scope == VotingScope.local
                              ? colorScheme.primary
                              : voting.scope == VotingScope.regional
                                  ? colorScheme.tertiary
                                  : colorScheme.secondary,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (voting.userHasVoted)
                      StatusPill(
                        label: 'Zagłosowano',
                        color: Colors.green,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  voting.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow(
                            icon: Icons.timer_outlined,
                            text: 'Kończy się za ${_timeLeftLabel(voting.endsAt)}',
                            color: urgent ? colorScheme.error : colorScheme.onSurface,
                            bold: urgent,
                          ),
                          const SizedBox(height: 6),
                          _infoRow(
                            icon: Icons.people_alt_outlined,
                            text: '${voting.participantCount} uczestników',
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ],
                      ),
                    ),
                    if (voting.userDelegated)
                      StatusPill(
                        label: 'Delegacja',
                        color: colorScheme.primary,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: voting.turnout.clamp(0.0, 1.0),
                          minHeight: 8,
                          backgroundColor: colorScheme.surfaceContainerLowest,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            urgent ? colorScheme.error : colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(voting.turnout * 100).round()}%',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String text,
    required Color color,
    bool bold = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  static String _timeLeftLabel(DateTime endsAt) {
    final diff = endsAt.difference(DateTime.now());
    if (diff.inDays > 0) {
      return '${diff.inDays} dni';
    }
    if (diff.inHours > 0) {
      return '${diff.inHours} godz.';
    }
    return '${diff.inMinutes} min';
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.action,
  });

  final String title;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: action,
            child: const Text('Zobacz więcej'),
          ),
      ],
    );
  }
}

class DetailInfoRow extends StatelessWidget {
  const DetailInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CitizenListTile extends StatelessWidget {
  const CitizenListTile({
    super.key,
    required this.profile,
    required this.onTap,
    this.trailing,
  });

  final CitizenProfile profile;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
        child: Text(
          profile.fullName.split(' ').map((e) => e[0]).take(2).join(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(profile.fullName),
      subtitle: Text('${profile.location} • ${profile.participationRate}% udziału'),
      trailing: trailing,
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppRoutesHelper {
  static String votingDetailPath(String id) => '${AppRoutes.eVoting}/$id';
  static String votingVotePath(String id) => '${AppRoutes.eVoting}/$id/vote';
  static String citizenProfilePath(String citizenId) => '${AppRoutes.eVoting}/citizen/$citizenId';
  static String delegationsPath() => '${AppRoutes.eVoting}/delegations';
  static String myVotesPath() => '${AppRoutes.eVoting}/my-votes';
}
