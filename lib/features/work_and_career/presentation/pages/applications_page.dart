import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/widgets/action_group.dart';
import 'package:obywatel_plus/core/design/widgets/action_tile.dart';
import 'package:obywatel_plus/core/design/widgets/app_avatar.dart';
import 'package:obywatel_plus/core/design/widgets/app_card.dart';

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListView(
      children: [
        _buildUserHeader(theme, colorScheme),

        const SizedBox(height: 24),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildStatCard('12', 'Wysłane', Colors.blue),
            _buildStatCard('3', 'Rozmowy', Colors.green),
            _buildStatCard('5', 'Oczekujące', Colors.orange),
          ],
        ),

        const SizedBox(height: 24),

        ActionGroup(
          title: 'Ostatnie aplikacje',
          children: [
            ActionTile(
              icon: Icons.work,
              title: 'Flutter Developer',
              subtitle: 'Tech Solutions • Warszawa',
              showArrow: true,
              onTap: () {},
            ),
            ActionTile(
              icon: Icons.work_outline,
              title: 'Backend Engineer',
              subtitle: 'Innovatech • Kraków',
              showArrow: true,
              onTap: () {},
            ),
            ActionTile(
              icon: Icons.design_services,
              title: 'UI/UX Designer',
              subtitle: 'DesignHub • Remote',
              showArrow: true,
              onTap: () {},
            ),
          ],
        ),

        ActionGroup(
          title: 'Status aplikacji',
          children: [
            ActionTile(
              icon: Icons.schedule,
              title: 'W trakcie rozpatrywania',
              subtitle: '5 aplikacji',
              onTap: () {},
              showArrow: true,
            ),
            ActionTile(
              icon: Icons.check_circle,
              title: 'Zaakceptowane',
              subtitle: '2 aplikacje',
              onTap: () {},
              showArrow: true,
            ),
            ActionTile(
              icon: Icons.cancel,
              title: 'Odrzucone',
              subtitle: '4 aplikacje',
              isDanger: true,
              onTap: () {},
              showArrow: true,
            ),
          ],
        ),

        ActionGroup(
          title: 'Akcje',
          children: [
            ActionTile(icon: Icons.add, title: 'Nowa aplikacja', onTap: () {}),
            ActionTile(icon: Icons.edit, title: 'Edytuj CV', onTap: () {}),
            ActionTile(
              icon: Icons.notifications,
              title: 'Powiadomienia',
              value: true,
              onToggle: (_) {},
            ),
          ],
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildUserHeader(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const AppAvatar(username: 'Jan Kowalski'),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Twoje aplikacje',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Masz 12 aktywnych aplikacji',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
            tooltip: 'Odśwież dane',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String count, String label, Color color) {
    return AppCard(
      themeColor: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Text(
          '$count\n$label',
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold, height: 1.2),
        ),
      ),
    );
  }
}
