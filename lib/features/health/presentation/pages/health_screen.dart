import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:obywatel_plus/app/router/app_routes.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Zdrowie'),
        backgroundColor: const Color(0xFF1E1E2E),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
        children: [
          _buildHealthTile(
            context,
            title: 'E-recepty',
            icon: Icons.medication_liquid,
            color: Colors.blue,
            path: '${AppRoutes.health}/prescriptions',
          ),
          _buildHealthTile(
            context,
            title: 'Skierowania',
            icon: Icons.assignment,
            color: Colors.purple,
            path: '${AppRoutes.health}/referrals',
          ),
          _buildHealthTile(
            context,
            title: 'Historia',
            icon: Icons.history,
            color: Colors.orange,
            path: '${AppRoutes.health}/history',
          ),
          _buildHealthTile(
            context,
            title: 'Szczepienia',
            icon: Icons.vaccines,
            color: Colors.green,
            path: '${AppRoutes.health}/vaccinations',
          ),
        ],
      ),
    );
  }

  Widget _buildHealthTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String path,
  }) {
    return InkWell(
      onTap: () => context.push(path),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha:0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
