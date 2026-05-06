import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/tokens/container_size.dart';
import 'package:obywatel_plus/core/design/widgets/action_group.dart';
import 'package:obywatel_plus/core/design/widgets/action_tile.dart';
import 'package:obywatel_plus/core/design/widgets/app_avatar.dart';
import 'package:obywatel_plus/core/design/widgets/app_bar.dart';
import 'package:obywatel_plus/core/design/widgets/app_bottom_nav_bar.dart';
import 'package:obywatel_plus/core/design/widgets/app_card.dart';
import 'package:obywatel_plus/core/design/widgets/app_scaffold.dart';
import 'package:obywatel_plus/core/design/widgets/chat_badge.dart';
import 'package:obywatel_plus/core/design/widgets/user_badge.dart';

class InternshipsPage extends StatelessWidget {
  const InternshipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppScaffold(
      size: ContainerSize.medium,
      appBar: AppAppBar(
        title: 'Staże',
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
        ],
      ),

      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (_) {},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Oferty'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Zapisane',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Moje'),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),

      child: ListView(
        children: [
          const SizedBox(height: 12),

          // HERO HEADER
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer,
                  colorScheme.primaryContainer.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const AppAvatar(username: 'Intern'),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Programy stażowe',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Znajdź idealny start kariery',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const ChatBadge(text: 'NOWE'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // QUICK STATS
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              AppCard(
                themeColor: Colors.blue,
                child: const Text('120+\nOfert'),
              ),
              AppCard(themeColor: Colors.green, child: const Text('45\nFirm')),
              AppCard(
                themeColor: Colors.orange,
                child: const Text('8\nZapisanych'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // FEATURED INTERNSHIP
          ActionGroup(
            title: 'Polecane',
            children: [
              ListTile(
                leading: const Icon(Icons.star, color: Colors.amber),
                title: const Text('Flutter Internship'),
                subtitle: const Text('Tech Corp • Warszawa'),
                trailing: const UserBadge(
                  type: UserBadgeType.activity,
                  label: 'Top',
                ),
                onTap: () {},
              ),
            ],
          ),

          // LISTA STAŻY
          ActionGroup(
            title: 'Oferty staży',
            children: [
              ActionTile(
                icon: Icons.code,
                title: 'Frontend Intern',
                subtitle: 'Startup XYZ • Remote',
                showArrow: true,
                onTap: () {},
              ),
              ActionTile(
                icon: Icons.storage,
                title: 'Backend Intern',
                subtitle: 'DataCorp • Kraków',
                showArrow: true,
                onTap: () {},
              ),
              ActionTile(
                icon: Icons.design_services,
                title: 'UI/UX Intern',
                subtitle: 'DesignLab • Wrocław',
                showArrow: true,
                onTap: () {},
              ),
            ],
          ),

          // STATUS / FILTRY
          ActionGroup(
            title: 'Filtry',
            children: [
              ActionTile(
                icon: Icons.location_on,
                title: 'Lokalizacja',
                subtitle: 'Cała Polska',
                showArrow: true,
                onTap: () {},
              ),
              ActionTile(
                icon: Icons.work_outline,
                title: 'Typ',
                subtitle: 'Remote / Hybrid',
                showArrow: true,
                onTap: () {},
              ),
              ActionTile(
                icon: Icons.schedule,
                title: 'Czas trwania',
                subtitle: '3-6 miesięcy',
                showArrow: true,
                onTap: () {},
              ),
            ],
          ),

          // AKCJE
          ActionGroup(
            title: 'Twoje akcje',
            children: [
              ActionTile(
                icon: Icons.bookmark_add,
                title: 'Zapisane staże',
                onTap: () {},
                showArrow: true,
              ),
              ActionTile(
                icon: Icons.send,
                title: 'Moje aplikacje',
                onTap: () {},
                showArrow: true,
              ),
              ActionTile(
                icon: Icons.notifications,
                title: 'Alerty staży',
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
