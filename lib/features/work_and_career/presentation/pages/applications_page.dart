import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/action_group.dart';
import 'package:obywatel_plus/core/design/widgets/action_tile.dart';
import 'package:obywatel_plus/core/design/widgets/app_avatar.dart';
import 'package:obywatel_plus/core/design/widgets/app_bar.dart';
import 'package:obywatel_plus/core/design/widgets/app_bottom_nav_bar.dart';
import 'package:obywatel_plus/core/design/widgets/app_card.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';

class ApplicationsPage extends StatelessWidget {
  const ApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScaffold(
      size: ContainerSize.medium,
      appBar: AppAppBar(
        title: 'Aplikacje',
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
        ],
      ),

      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (_) {},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Wszystkie'),
          BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Wysłane'),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: 'Zaakceptowane',
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),

      child: ListView(
        children: [
          const SizedBox(height: 12),

          // HEADER USERA
          Container(
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
                IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // STATYSTYKI
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AppCard(
                themeColor: Colors.blue,
                child: const Text('12\nWysłane'),
              ),
              AppCard(
                themeColor: Colors.green,
                child: const Text('3\nRozmowy'),
              ),
              AppCard(
                themeColor: Colors.orange,
                child: const Text('5\nOczekujące'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // LISTA APLIKACJI
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

          // STATUSY
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

          // AKCJE
          ActionGroup(
            title: 'Akcje',
            children: [
              ActionTile(
                icon: Icons.add,
                title: 'Nowa aplikacja',
                onTap: () {},
              ),
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
      ),
    );
  }
}
