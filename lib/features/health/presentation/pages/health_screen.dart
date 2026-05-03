import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';
import 'package:obywatel_plus/core/design/widgets/app_card.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverPadding(padding: EdgeInsets.all(16), sliver: _HealthGrid()),
      ],
    );
  }
}

class _HealthGrid extends StatelessWidget {
  const _HealthGrid();

  @override
  Widget build(BuildContext context) {
    final items = [
      _HealthItem(
        'E-recepty',
        AppRoutes.healthPrescriptions,
        Icons.medication_liquid,
        Colors.blue,
      ),
      _HealthItem(
        'Skierowania',
        AppRoutes.healthReferrals,
        Icons.assignment,
        Colors.purple,
      ),
      _HealthItem(
        'Historia',
        AppRoutes.healthHistory,
        Icons.history,
        Colors.orange,
      ),
      _HealthItem(
        'Szczepienia',
        AppRoutes.healthVaccinations,
        Icons.vaccines,
        Colors.green,
      ),
    ];

    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        final item = items[index];

        return _buildHealthCard(
          context,
          title: item.title,
          route: '${AppRoutes.health}/${item.route}',
          icon: item.icon,
          color: item.color,
        );
      }, childCount: items.length),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
    );
  }

  Widget _buildHealthCard(
    BuildContext context, {
    required String title,
    required String route,
    required IconData icon,
    required Color color,
  }) {
    return AppCard(
      onTap: () => context.push(route),
      themeColor: color,
      icon: Icon(icon, color: color, size: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            'Zobacz szczegóły',
            style: TextStyle(fontSize: 11, color: color),
          ),
        ],
      ),
    );
  }
}

class _HealthItem {
  final String title;
  final String route;
  final IconData icon;
  final Color color;

  _HealthItem(this.title, this.route, this.icon, this.color);
}
