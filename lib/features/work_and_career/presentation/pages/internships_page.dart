import 'package:flutter/material.dart';
import 'package:obywatel_plus/core/design/widgets/action_group.dart';
import 'package:obywatel_plus/core/design/widgets/action_tile.dart';
import 'package:obywatel_plus/core/design/widgets/app_card.dart';
import 'package:obywatel_plus/core/design/widgets/user_badge.dart';

class InternshipsPage extends StatelessWidget {
  const InternshipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            AppCard(themeColor: Colors.blue, child: const Text('120+\nOfert')),
            AppCard(themeColor: Colors.green, child: const Text('45\nFirm')),
            AppCard(
              themeColor: Colors.orange,
              child: const Text('8\nZapisanych'),
            ),
          ],
        ),
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
      ],
    );
  }
}
